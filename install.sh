#!/bin/bash
# ============================================================================
#  TRISMEGISTUS - Mac/Linux Installation Script
#  "As above, so below; as within, so without."
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Banner
echo -e "${MAGENTA}"
cat << 'EOF'

  ___________      .__                                .__          __                
  \__    ___/______|__| ______ _____   ____   _____ |__|  ______/  |_ __ __  ______
    |    |  \_  __ \  |/  ___//     \_/ __ \ / ___\ |  | /  ___/\   __\  |  \/  ___/
    |    |   |  | \/  |\___ \|  Y Y  \  ___// /_/  >|  | \___ \  |  | |  |  /\___ \ 
    |____|   |__|  |__/____  >__|_|  /\___  >___  / |__|/____  > |__| |____//____  >
                           \/      \/     \/_____/           \/                  \/ 

                              I N S T A L L E R   v1.0

EOF
echo -e "${NC}"

INSTALL_PATH="$HOME/.trismegistus"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
SKIP_SHELL=false
FORCE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-shell) SKIP_SHELL=true; shift ;;
        --force) FORCE=true; shift ;;
        --path) INSTALL_PATH="$2"; shift 2 ;;
        *) shift ;;
    esac
done

echo -e "${CYAN}[1/5] Checking prerequisites...${NC}"

# Check PowerShell
if command -v pwsh &> /dev/null; then
    PS_VERSION=$(pwsh -Version | head -1)
    echo -e "  ${GREEN}[OK]${NC} PowerShell: $PS_VERSION"
else
    echo ""
    echo -e "  ${RED}ERROR: PowerShell 7+ required${NC}"
    echo ""
    echo -e "  ${YELLOW}Install PowerShell:${NC}"
    echo "    macOS:  brew install powershell"
    echo "    Ubuntu: sudo apt-get install -y powershell"
    echo "    Fedora: sudo dnf install -y powershell"
    echo ""
    echo "  Or visit: https://aka.ms/powershell"
    echo ""
    exit 1
fi

# Check Git
if command -v git &> /dev/null; then
    echo -e "  ${GREEN}[OK]${NC} Git installed"
else
    echo -e "  ${RED}[X]${NC} Git not found"
    exit 1
fi

# Check for AI CLIs
HAS_ORACLE=false
for oracle in claude gemini ollama openai codex; do
    if command -v $oracle &> /dev/null; then
        echo -e "  ${GREEN}[OK]${NC} $oracle CLI found"
        HAS_ORACLE=true
    fi
done

if [ "$HAS_ORACLE" = false ]; then
    echo ""
    echo -e "  ${YELLOW}WARNING: No AI CLIs detected!${NC}"
    echo -e "  ${YELLOW}Install at least one:${NC}"
    echo "    - claude:  npm install -g @anthropic-ai/claude-cli"
    echo "    - gemini:  npm install -g @google/gemini-cli"
    echo "    - ollama:  https://ollama.ai"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo ""
echo -e "${CYAN}[2/5] Installing to: $INSTALL_PATH${NC}"

# Check existing installation
if [ -d "$INSTALL_PATH" ] && [ "$FORCE" = false ]; then
    echo -e "  ${YELLOW}Existing installation found.${NC}"
    read -p "  Overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Create install directory
rm -rf "$INSTALL_PATH"
mkdir -p "$INSTALL_PATH"

# Copy files
for folder in core themes templates config; do
    if [ -d "$SCRIPT_DIR/$folder" ]; then
        cp -r "$SCRIPT_DIR/$folder" "$INSTALL_PATH/"
        echo -e "  ${GREEN}[OK]${NC} Copied $folder/"
    fi
done

echo ""
echo -e "${CYAN}[3/5] Setting environment variables...${NC}"

# Environment variables will be set in shell config
echo -e "  ${GREEN}[OK]${NC} TRIS_ROOT = $INSTALL_PATH"
echo -e "  ${GREEN}[OK]${NC} TRIS_TEMPLATES = $INSTALL_PATH/templates"

echo ""
echo -e "${CYAN}[4/5] Configuring shell...${NC}"

if [ "$SKIP_SHELL" = false ]; then
    # Detect shell config file
    SHELL_CONFIG=""
    if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.profile" ]; then
        SHELL_CONFIG="$HOME/.profile"
    fi
    
    if [ -n "$SHELL_CONFIG" ]; then
        # Shell config content
        SHELL_CONTENT="
# ============================================================================
# TRISMEGISTUS - Multi-Oracle Agentic Orchestrator
# ============================================================================
export TRIS_ROOT=\"$INSTALL_PATH\"
export TRIS_TEMPLATES=\"$INSTALL_PATH/templates\"

# Quick entry to Trismegistus PowerShell environment
tris() {
    pwsh -NoExit -Command \". '\$env:TRIS_ROOT/core/profile.ps1'\"
}

# Convenience aliases (run PowerShell commands from bash)
alias ai-help='pwsh -Command \"ai-help\"'
alias ai-status='pwsh -Command \"ai-status\"'
# ============================================================================
"
        
        # Check if already installed
        if grep -q "TRISMEGISTUS" "$SHELL_CONFIG" 2>/dev/null; then
            echo -e "  ${YELLOW}Shell config already contains Trismegistus. Updating...${NC}"
            # Remove old installation (between markers)
            sed -i.bak '/# ===.*TRISMEGISTUS/,/# ===/d' "$SHELL_CONFIG"
        fi
        
        echo "$SHELL_CONTENT" >> "$SHELL_CONFIG"
        echo -e "  ${GREEN}[OK]${NC} Updated: $SHELL_CONFIG"
    else
        echo -e "  ${YELLOW}Could not detect shell config file${NC}"
        echo "  Add manually to your shell config:"
        echo "    export TRIS_ROOT=\"$INSTALL_PATH\""
        echo "    export TRIS_TEMPLATES=\"$INSTALL_PATH/templates\""
    fi
else
    echo -e "  ${YELLOW}Skipped (--skip-shell)${NC}"
fi

echo ""
echo -e "${CYAN}[5/5] Finalizing...${NC}"

# Create default config
CONFIG_PATH="$INSTALL_PATH/config.json"
if [ ! -f "$CONFIG_PATH" ]; then
    cat > "$CONFIG_PATH" << 'CONFIGEOF'
{
  "default": "claude",
  "theme": "hermetic",
  "routing": {},
  "providers": {
    "claude": { "enabled": true, "model": "claude-sonnet-4-20250514" },
    "gemini": { "enabled": false, "model": "gemini-2.5-pro" },
    "ollama": { "enabled": false, "model": "llama3.2" },
    "openai": { "enabled": false, "model": "gpt-4o" }
  },
  "preferences": {
    "protectedBranches": ["main", "master", "production"],
    "maxContextFiles": 3000,
    "lessonsWarnThreshold": 100
  }
}
CONFIGEOF
    echo -e "  ${GREEN}[OK]${NC} Created default configuration"
fi

echo -e "  ${GREEN}[OK]${NC} Installation complete!"

# Done
echo -e "${CYAN}"
cat << 'EOF'

+========================================================================+
|                    INSTALLATION COMPLETE                               |
+========================================================================+

  Next steps:

  1. Reload your shell:
     source ~/.bashrc   # or ~/.zshrc

  2. Enter Trismegistus environment:
     tris

  3. Run first-time setup:
     ai-setup

  4. Or jump straight in:
     cd your-project
     ai-init
     ai-plan "Your first task"

  5. View all commands:
     ai-help

  "As above, so below; as within, so without."

EOF
echo -e "${NC}"
