#!/usr/bin/env bash
# verify-install.sh — Cek apakah installasi Hermes Agent bener-bener OK
# Usage: curl -fsSL https://.../verify-install.sh | bash
#        ATAU: bash verify-install.sh

set -uo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[✓]${NC} $*"; }
fail() { echo -e "${RED}[✗]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
info() { echo -e "${BLUE}[i]${NC} $*"; }

PASS=0
FAIL=0

check() {
  local name="$1"
  local cmd="$2"
  local expected="$3"

  info "Check: $name"
  local out
  if out=$(eval "$cmd" 2>&1); then
    if [[ -z "$expected" ]] || [[ "$out" == *"$expected"* ]]; then
      ok "  → $out"
      PASS=$((PASS + 1))
    else
      fail "  → $out (expected: $expected)"
      FAIL=$((FAIL + 1))
    fi
  else
    fail "  → $out"
    FAIL=$((FAIL + 1))
  fi
}

echo -e "${BLUE}"
cat << "EOF"
  ╦ ╦┌─┐┬  ┬  ┌─┐┌─┐┌─┐┌─┐┌─┐
  ╠═╣├┤ │  │  │ ││ ┬├┤ ├─┤└─┐
  ╩ ╩└─┘┴─┘┴─┘└─┘└─┘└─┘┴ ┴└─┘
  Hermes Agent — Install Verification
EOF
echo -e "${NC}"

echo "============================================"
echo " 1. System Requirements"
echo "============================================"

# Python
check "Python 3.10+" "python3 -c 'import sys; v=sys.version_info; print(f\"{v.major}.{v.minor}.{v.micro}\") if v.major>=3 and v.minor>=10 else exit(1)'" ""

# pip
check "pip available" "python3 -m pip --version" "pip"

# curl
check "curl" "command -v curl && curl --version | head -1" "curl"

# git
check "git" "command -v git && git --version" "git"

echo ""
echo "============================================"
echo " 2. Hermes Agent Install"
echo "============================================"

# hermes binary
if command -v hermes &>/dev/null; then
  check "hermes --version" "hermes --version" ""
  check "hermes --help" "hermes --help 2>&1 | head -3" "hermes"
else
  fail "hermes command NOT FOUND. PATH belum di-set atau install gagal."
  FAIL=$((FAIL + 1))
  info "Coba: source ~/.bashrc, atau PATH=\$HOME/.local/bin:\$PATH"
fi

echo ""
echo "============================================"
echo " 3. Hermes Config"
echo "============================================"

# config dir
check "~/.hermes exists" "test -d ~/.hermes && echo OK || echo MISSING" "OK"

# config.yaml
if [[ -f ~/.hermes/config.yaml ]]; then
  ok "  config.yaml present"
  PASS=$((PASS + 1))
  # Check if model is set
  if grep -q "^model:" ~/.hermes/config.yaml 2>/dev/null; then
    ok "  model section configured"
    PASS=$((PASS + 1))
    info "  current model: $(grep 'default:' ~/.hermes/config.yaml | head -1 | awk '{print $2}')"
  else
    warn "  model section belum di-set. Jalankan: hermes setup"
  fi
else
  warn "  config.yaml belum ada. Jalankan: hermes setup"
fi

# .env file
if [[ -f ~/.hermes/.env ]]; then
  ok "  .env present"
  PASS=$((PASS + 1))
  # Check API keys (jangan display value, hanya presence — pattern = prefix umum)
  if grep -qE "^GROQ_API_KEY=(gsk_|sk-)[A-Za-z0-9_-]{10,}" "$HERMES_ENV" 2>/dev/null; then
    ok "  GROQ_API_KEY set"
    PASS=$((PASS + 1))
  fi
  if grep -qE "^NVIDIA_API_KEY=nvapi-[A-Za-z0-9_-]{10,}" "$HERMES_ENV" 2>/dev/null; then
    ok "  NVIDIA_API_KEY set"
    PASS=$((PASS + 1))
  fi
  if grep -qE "^CLOUDFLARE_API_TOKEN=[A-Za-z0-9_-]{20,}" "$HERMES_ENV" 2>/dev/null; then
    ok "  CLOUDFLARE_API_TOKEN set"
    PASS=$((PASS + 1))
  fi
else
  warn "  .env belum ada. Setup API key dengan: hermes setup"
fi

echo ""
echo "============================================"
echo " 4. Optional Tools (untuk fitur lengkap)"
echo "============================================"

# ffmpeg
check "ffmpeg" "command -v ffmpeg && ffmpeg -version 2>&1 | head -1" "ffmpeg"

# faster-whisper (optional, untuk STT lokal)
check "faster-whisper (optional)" "python3 -c 'import faster_whisper' 2>&1 && echo installed || echo missing" ""

echo ""
echo "============================================"
echo " SUMMARY"
echo "============================================"
echo ""
ok "Passed: $PASS"
if [[ $FAIL -gt 0 ]]; then
  fail "Failed: $FAIL"
  echo ""
  warn "Ada yang gagal. Cek pesan di atas dan lihat README troubleshooting."
  exit 1
else
  ok "SEMUA CHECK PASS! 🎉"
  echo ""
  info "Test chat:"
  echo "  hermes chat -q \"Halo, apa kabar?\""
  echo ""
fi
