#!/usr/bin/env bash
# demo.sh — Script untuk di-record asciinema jadi demo.gif
# Menunjukkan alur lengkap: install → doctor → setup → test chat
# Pakai fake/stub commands supaya GIF aman tanpa API key asli.

set -euo pipefail

# Speed control (untuk pacing GIF)
SLOW=0.3
FAST=0.1

# Color codes untuk terminal
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

# Fake "hermes" command buat demo (no real install)
hermes() {
  case "${1:-}" in
    --version)
      echo "hermes-agent 1.0.0 (linux x86_64)"
      ;;
    doctor)
      cat <<'EOF'
🔍 Hermes Doctor — System Check
──────────────────────────────────────────

✓ Python 3.11.15 detected
✓ pip 24.0 available
✓ Git 2.43.0 found
✓ ~/.hermes directory writable
✓ Network: 124ms to api.groq.com
✓ All required dependencies installed

System: ✓ HEALTHY
EOF
      ;;
    --help)
      cat <<'EOF'
Hermes Agent — AI coding agent

Usage: hermes [command] [options]

Commands:
  chat            Start interactive chat
  setup           Configure provider + API key
  model           Change model/provider
  doctor          System health check
  gateway         Run messaging gateway
  update          Update to latest version
  skills          Manage skills
  cron            Manage scheduled jobs

Run 'hermes <command> --help' for details.
EOF
      ;;
    setup)
      cat <<'EOF'
🚀 Hermes Setup Wizard
──────────────────────────────────────────

Select your primary provider:

  1) groq         (Recommended — unlimited free)
  2) nvidia       (Best quality, 1000 req/bulan)
  3) cloudflare   (10K req/hari)
  4) openrouter   (100+ models, 1 key)
  5) google       (Gemini)
  6) custom       (manual config)

Choice [1-6]: 1
✓ Provider: groq
✓ API Key: gsk_demo*** (loaded from ~/.hermes/.env)
✓ Model: groq/llama-3.3-70b-versatile
✓ Context: 131K tokens

✓ Setup complete! Run 'hermes chat' to start.
EOF
      ;;
    chat)
      case "${2:-}" in
        -q)
          shift 2
          local query="$*"
          if [[ -z "$query" ]]; then
            echo "Error: empty query"
            return 1
          fi
          # Simulate response
          echo ""
          echo -e "${CYAN}╭─ Hermes Agent ────────────────────────────╮${NC}"
          echo -e "${CYAN}│${NC} ${DIM}groq/llama-3.3-70b-versatile · 124ms${NC}"
          echo -e "${CYAN}╰───────────────────────────────────────────╯${NC}"
          echo ""
          case "$query" in
            *"Halo"*|*"halo"*|*"Hi"*|*"hi"*)
              echo "Halo! Saya Hermes Agent, AI assistant kamu. Ada yang bisa saya bantu hari ini? 😊"
              echo ""
              echo "Saya bisa bantu:"
              echo "  • Coding (Python, JS, Go, Rust, dll)"
              echo "  • System administration (Linux, Docker, K8s)"
              echo "  • Trading & crypto analysis"
              echo "  • Research & web search"
              echo "  • Otomatisasi task harian"
              ;;
            *"quantum"*|*"Quantum"*)
              echo "Quantum computing dalam bahasa sederhana:"
              echo ""
              echo "Bayangkan komputer biasa pakai 'bit' — nilainya 0 atau 1."
              echo "Komputer quantum pakai 'qubit' — bisa 0, 1, atau KEDUANYA sekaligus (superposition)."
              echo ""
              echo "Ini bikin komputer quantum bisa solve masalah tertentu"
              echo "(kriptografi, simulasi molekul, optimasi) jauh lebih cepat"
              echo "daripada komputer biasa."
              ;;
            *"Python"*|*"python"*)
              echo "Python itu bahasa pemrograman serba guna — salah satu yang paling populer di dunia."
              echo ""
              echo "Kelebihan:"
              echo "  • Sintaksis mudah dibaca (mirip bahasa Inggris)"
              echo "  • Library lengkap (NumPy, Pandas, FastAPI, dll)"
              echo "  • Komunitas besar"
              echo "  • Cocok untuk AI/ML, web, automation, data science"
              echo ""
              echo "Contoh 'Hello World':"
              echo "  print('Hello, world!')"
              ;;
            *)
              echo "Pertanyaan kamu: \"$query\""
              echo ""
              echo "Ini jawaban simulado untuk demo GIF. Di real environment,"
              echo "Hermes akan call API Groq/NVIDIA/Cloudflare dan return jawaban"
              echo "asli dari LLM provider."
              ;;
          esac
          echo ""
          echo -e "${DIM}Tokens: 142 in / 87 out · Cost: \$0.00 (free tier)${NC}"
          echo ""
          ;;
        *)
          cat <<'EOF'
╭─ Hermes Agent ────────────────────────────╮
│ Type your message below.                  │
│ Commands: /help /clear /exit              │
╰───────────────────────────────────────────╯

hermes>
EOF
          ;;
      esac
      ;;
    model)
      cat <<'EOF'
📦 Current Model Configuration
──────────────────────────────────────────

Provider:    groq
Model:       groq/llama-3.3-70b-versatile
Context:     131,072 tokens
Speed:       ~180 tokens/sec (LPU)
Cost:        $0.00 (free tier)

Available models:
  1) groq/llama-3.3-70b-versatile      [default]
  2) groq/llama-3.1-8b-instant         [fastest]
  3) groq/llama-4-maverick-17b-128e    [latest]
  4) groq/mixtral-8x7b-32768           [coding]

Change with: hermes config set model.default <name>
EOF
      ;;
    skills)
      cat <<'EOF'
📚 Installed Skills
──────────────────────────────────────────

  ✓ hermes-agent           Hermes configuration
  ✓ public-tool-publishing Ship to GitHub + GIF demo
  ✓ free-api-curation      Free API discovery
  ✓ crypto-bybit-bridge    Bybit trading
  ✓ forex-xau-analysis     Gold analysis
  ✓ codex-delegation       Codex CLI delegation
  ✓ subagent-dev           Plan execution

Total: 7 skills installed
EOF
      ;;
    gateway)
      cat <<'EOF'
🌐 Gateway Status
──────────────────────────────────────────

  ✓ Telegram   connected (@HermesAgentBot)
  ✓ Discord    connected (CUANOLOGY)
  ✗ Slack      not configured

Run 'hermes gateway setup' to add platform.
EOF
      ;;
    *)
      echo "hermes: unknown command '$1' (use --help)"
      return 1
      ;;
  esac
}

# Main demo flow
clear

echo -e "${BOLD}${CYAN}"
cat << "EOF"
   _   _                     _   ___            _
  | | | | ___  _ __ ___   __| | |_ _|___  _ __ | | __ _ _   _ ___
  | |_| |/ _ \| '_ ` _ \ / _` |  | |/ _ \| '_ \| |/ _` | | | / __|
  |  _  | (_) | | | | | | (_| |  | | (_) | |_) | | (_| | |_| \__ \
  |_| |_|\___/|_| |_| |_|\__,_| |___\___/| .__/|_|\__,_|\__, |___/
                                         |_|            |___/
EOF
echo -e "${NC}"
echo -e "${DIM}AI coding agent — open source, multi-provider, free tier ready${NC}"
echo ""
sleep 1.5

echo -e "${GREEN}\$ curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash${NC}"
sleep 0.5
echo ""
echo -e "${DIM}→ Detecting distro... Ubuntu 24.04 LTS${NC}"
sleep 0.3
echo -e "${DIM}→ Checking Python... 3.11.15 ✓${NC}"
sleep 0.3
echo -e "${DIM}→ Installing dependencies... ✓${NC}"
sleep 0.3
echo -e "${DIM}→ Installing hermes-agent via pip... ✓${NC}"
sleep 0.3
echo -e "${DIM}→ Setting up PATH in ~/.bashrc... ✓${NC}"
sleep 0.3
echo -e "${GREEN}✓ INSTALL SELESAI!${NC}"
sleep 1

echo ""
echo -e "${GREEN}\$ hermes --version${NC}"
sleep 0.3
hermes --version
sleep 1

echo ""
echo -e "${GREEN}\$ hermes doctor${NC}"
sleep 0.3
hermes doctor
sleep 1.5

echo ""
echo -e "${GREEN}\$ hermes setup${NC}"
sleep 0.3
hermes setup
sleep 2

echo ""
echo -e "${GREEN}\$ hermes model${NC}"
sleep 0.3
hermes model
sleep 1.5

echo ""
echo -e "${GREEN}\$ hermes chat -q \"Halo, apa kabar?\"${NC}"
sleep 0.3
hermes chat -q "Halo, apa kabar?"
sleep 2

echo ""
echo -e "${GREEN}\$ hermes chat -q \"Jelasin quantum computing singkat\"${NC}"
sleep 0.3
hermes chat -q "Jelasin quantum computing singkat"
sleep 2

echo ""
echo -e "${GREEN}\$ hermes skills${NC}"
sleep 0.3
hermes skills
sleep 1.5

echo ""
echo -e "${GREEN}\$ hermes gateway status${NC}"
sleep 0.3
hermes gateway
sleep 1.5

echo ""
echo -e "${BOLD}${CYAN}🎉 Done! Lo udah punya AI agent unlimited gratis.${NC}"
echo ""
echo -e "${DIM}Repo: github.com/Celebez/hermes-agent-install-free-api${NC}"
echo -e "${DIM}Docs: hermes-agent.nousresearch.com/docs/${NC}"
echo ""
sleep 3
