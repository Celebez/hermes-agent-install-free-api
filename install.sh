#!/usr/bin/env bash
# install.sh — One-line installer untuk Hermes Agent (Linux)
# Usage: curl -fsSL https://... | bash
# Tested: Ubuntu 24.04, Debian 12, Fedora 41, Arch 2026-06

set -euo pipefail

HERMES_INSTALL_VERSION="${HERMES_INSTALL_VERSION:-latest}"
HERMES_USER_BIN="${HOME}/.local/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
err()   { echo -e "${RED}[✗]${NC} $*" >&2; }

# Detect distro
detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID="${ID:-unknown}"
    DISTRO_LIKE="${ID_LIKE:-}"
  else
    DISTRO_ID="unknown"
    DISTRO_LIKE=""
  fi
  info "Detected distro: $DISTRO_ID ($DISTRO_LIKE)"
}

# Check Python
check_python() {
  if ! command -v python3 &>/dev/null; then
    err "Python 3 tidak ketemu. Install dulu: sudo apt install python3"
    exit 1
  fi

  PY_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
  PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
  PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)

  if [[ "$PY_MAJOR" -lt 3 ]] || [[ "$PY_MAJOR" -eq 3 && "$PY_MINOR" -lt 10 ]]; then
    err "Python 3.10+ required, found $PY_VERSION"
    exit 1
  fi
  ok "Python $PY_VERSION"
}

# Install build dependencies per distro
install_deps() {
  info "Installing build dependencies..."

  case "$DISTRO_ID" in
    ubuntu|debian|pop|mint|elementary)
      sudo apt update -qq
      sudo apt install -y -qq curl git python3 python3-venv python3-pip build-essential
      ;;
    fedora|rhel|rocky|almalinux|centos)
      sudo dnf install -y -q curl git python3 python3-pip python3-devel gcc make
      ;;
    arch|manjaro|endeavouros)
      sudo pacman -S --needed --noconfirm curl git python python-pip base-devel
      ;;
    opensuse|suse)
      sudo zypper install -y curl git python3 python3-pip gcc make
      ;;
    *)
      warn "Distro $DISTRO_ID tidak dikenali. Coba install manual: curl, git, python3, pip, gcc, make"
      ;;
  esac

  ok "Dependencies installed"
}

# Install Hermes Agent
install_hermes() {
  info "Installing Hermes Agent..."

  # Try pip user install first (recommended)
  if python3 -m pip install --user --quiet hermes-agent 2>/dev/null; then
    ok "Installed via pip --user"
  else
    # Fallback: venv approach
    warn "pip --user gagal, coba venv approach..."
    python3 -m venv "${HOME}/.hermes/venv"
    # shellcheck disable=SC1091
    source "${HOME}/.hermes/venv/bin/activate"
    pip install --quiet hermes-agent
    ok "Installed in venv ${HOME}/.hermes/venv"
  fi

  # Ensure ~/.local/bin exists
  mkdir -p "$HERMES_USER_BIN"
}

# Setup PATH
setup_path() {
  SHELL_RC=""
  if [[ -n "${BASH_VERSION:-}" ]] && [[ -f "${HOME}/.bashrc" ]]; then
    SHELL_RC="${HOME}/.bashrc"
  elif [[ -n "${ZSH_VERSION:-}" ]] && [[ -f "${HOME}/.zshrc" ]]; then
    SHELL_RC="${HOME}/.zshrc"
  fi

  if [[ -n "$SHELL_RC" ]] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
    echo '' >> "$SHELL_RC"
    echo '# Hermes Agent PATH' >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    ok "Added PATH to $SHELL_RC"
  fi

  export PATH="$HERMES_USER_BIN:$PATH"
}

# Verify install
verify() {
  if command -v hermes &>/dev/null; then
    HERMES_VER=$(hermes --version 2>&1 | head -1 || echo "unknown")
    ok "Hermes installed: $HERMES_VER"
  else
    warn "Hermes command belum ada di PATH. Coba: source ~/.bashrc"
  fi
}

# Main
main() {
  echo -e "${BLUE}"
  cat << "EOF"
   _   _                     _   ___            _
  | | | | ___  _ __ ___   __| | |_ _|___  _ __ | | __ _ _   _ ___
  | |_| |/ _ \| '_ ` _ \ / _` |  | |/ _ \| '_ \| |/ _` | | | / __|
  |  _  | (_) | | | | | | (_| |  | | (_) | |_) | | (_| | |_| \__ \
  |_| |_|\___/|_| |_| |_|\__,_| |___\___/| .__/|_|\__,_|\__, |___/
                                         |_|            |___/
        Installer — Linux (Ubuntu/Debian/Fedora/Arch)
EOF
  echo -e "${NC}"

  detect_distro
  check_python
  install_deps
  install_hermes
  setup_path
  verify

  echo ""
  ok "INSTALL SELESAI!"
  echo ""
  info "Langkah selanjutnya:"
  echo "  1. source ~/.bashrc   (atau buka terminal baru)"
  echo "  2. hermes doctor      (verifikasi instalasi)"
  echo "  3. hermes setup       (setup API key)"
  echo ""
  info "Belum punya API key? Cek: https://github.com/Celebez/hermes-agent-install-free-api"
  echo ""
}

main "$@"
