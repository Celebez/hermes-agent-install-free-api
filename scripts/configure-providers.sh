#!/usr/bin/env bash
# configure-providers.sh — Interactive setup buat 1+ provider sekaligus
# Usage: bash configure-providers.sh
#        ATAU: bash configure-providers.sh --auto  (skip prompt, baca dari .env.template)

set -uo pipefail

HERMES_DIR="${HOME}/.hermes"
HERMES_ENV="${HERMES_DIR}/.env"
HERMES_CONFIG="${HERMES_DIR}/config.yaml"

mkdir -p "$HERMES_DIR"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[✓]${NC} $*"; }
info() { echo -e "${BLUE}[i]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*" >&2; }

# Load existing .env kalau ada
if [[ -f "$HERMES_ENV" ]]; then
  # shellcheck disable=SC1090
  source "$HERMES_ENV"
  ok "Loaded existing .env dari $HERMES_ENV"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Hermes Agent — Provider Configuration Wizard${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""
info "Pilih provider yang mau di-setup. Bisa pilih lebih dari satu."
info "Kosongkan input (Enter) buat skip."
echo ""

configure_provider() {
  local name="$1"
  local env_var="$2"
  local default_model="$3"
  local base_url="${4:-}"
  local signup_url="$5"
  local current_value="${!env_var:-}"

  echo ""
  echo -e "${BLUE}─────────────────────────────────────────────${NC}"
  echo -e "  Provider: ${GREEN}$name${NC}"
  echo -e "  Signup:   ${BLUE}$signup_url${NC}"
  if [[ -n "$current_value" ]]; then
    echo -e "  Current:  ${GREEN}$(echo "$current_value" | cut -c1-12)***${NC} (sudah ada)"
    read -rp "  Replace? [y/N]: " replace
    [[ "$replace" =~ ^[Yy]$ ]] || return 0
  fi
  read -rp "  API Key (kosongkan utk skip): " api_key
  if [[ -z "$api_key" ]]; then
    warn "  Skip $name"
    return 0
  fi

  # Save ke .env
  if grep -q "^${env_var}=" "$HERMES_ENV" 2>/dev/null; then
    sed -i "s|^${env_var}=.*|${env_var}=${api_key}|" "$HERMES_ENV"
  else
    echo "${env_var}=${api_key}" >> "$HERMES_ENV"
  fi
  ok "  Saved $env_var ke $HERMES_ENV"

  # Set as default model kalau ini provider pertama
  if [[ ! -f "$HERMES_CONFIG" ]] || ! grep -q "^model:" "$HERMES_CONFIG" 2>/dev/null; then
    info "  Set sebagai default model..."
    hermes config set model.default "$default_model" 2>/dev/null || true
    [[ -n "$base_url" ]] && hermes config set model.base_url "$base_url" 2>/dev/null || true
    local provider_id
    provider_id=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr -d ' ' | head -c 20)
    hermes config set model.provider "$provider_id" 2>/dev/null || true
    ok "  Default model: $default_model"
  fi
}

# 1. Groq
configure_provider \
  "Groq (Recommended - Unlimited)" \
  "GROQ_API_KEY" \
  "groq/llama-3.3-70b-versatile" \
  "" \
  "https://console.groq.com/keys"

# 2. NVIDIA NIM
configure_provider \
  "NVIDIA NIM (Best Quality - 1000 req/bulan)" \
  "NVIDIA_API_KEY" \
  "nvidia/nemotron-3-super-120b-a12b" \
  "https://integrate.api.nvidia.com/v1" \
  "https://build.nvidia.com"

# 3. Cloudflare Workers AI
configure_provider \
  "Cloudflare Workers AI (10K req/hari)" \
  "CLOUDFLARE_API_TOKEN" \
  "@cf/meta/llama-3.3-70b-instruct-fp8-fast" \
  "" \
  "https://dash.cloudflare.com/profile/api-tokens"

# 4. OpenRouter
configure_provider \
  "OpenRouter (100+ model, 1 key)" \
  "OPENROUTER_API_KEY" \
  "openrouter/meta-llama/llama-3.3-70b-instruct:free" \
  "" \
  "https://openrouter.ai/keys"

# 5. Google AI Studio (Gemini)
configure_provider \
  "Google AI Studio (Gemini)" \
  "GOOGLE_API_KEY" \
  "google/gemini-2.0-flash" \
  "" \
  "https://aistudio.google.com/apikey"

# 6. Cerebras
configure_provider \
  "Cerebras (1M tokens/hari)" \
  "CEREBRAS_API_KEY" \
  "cerebras/llama-3.3-70b" \
  "" \
  "https://inference.cerebras.ai"

# 7. Mistral
configure_provider \
  "Mistral AI" \
  "MISTRAL_API_KEY" \
  "mistral/mistral-large-latest" \
  "" \
  "https://console.mistral.ai"

# 8. Cohere
configure_provider \
  "Cohere (Command R+)" \
  "COHERE_API_KEY" \
  "cohere/command-r-plus" \
  "" \
  "https://dashboard.cohere.ai/api-keys"

# 9. Hugging Face
configure_provider \
  "Hugging Face" \
  "HF_TOKEN" \
  "huggingface/meta-llama/Llama-3.3-70B-Instruct" \
  "" \
  "https://huggingface.co/settings/tokens"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
ok "Configuration selesai!"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""
info "Test koneksi:"
echo "  hermes chat -q \"Halo, apa kabar?\""
echo ""
info "Switch model:"
echo "  hermes model"
echo ""
info "File yang di-update:"
echo "  - $HERMES_ENV (API keys)"
echo "  - $HERMES_CONFIG (default model)"
echo ""
warn "JANGAN commit $HERMES_ENV ke Git!"
echo ""
