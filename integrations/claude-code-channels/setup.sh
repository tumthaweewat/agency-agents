#!/usr/bin/env bash
# Claude Code Channels Setup Script
# Sets up Telegram and/or Discord channels for Claude Code
set -euo pipefail

BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
  echo ""
  echo -e "${BOLD}Claude Code Channels Setup${NC}"
  echo -e "${DIM}Unified notifications from Discord & Telegram${NC}"
  echo ""
}

check_prerequisites() {
  local missing=0

  if ! command -v claude &>/dev/null; then
    echo -e "${RED}Error: Claude Code is not installed.${NC}"
    echo "  Install it from: https://code.claude.com"
    missing=1
  fi

  if ! command -v bun &>/dev/null; then
    echo -e "${RED}Error: Bun runtime is not installed.${NC}"
    echo "  Install it from: https://bun.sh"
    echo "  curl -fsSL https://bun.sh/install | bash"
    missing=1
  fi

  if [ "$missing" -eq 1 ]; then
    echo ""
    echo -e "${YELLOW}Please install the missing prerequisites and try again.${NC}"
    exit 1
  fi

  echo -e "${GREEN}Prerequisites OK${NC} (Claude Code + Bun detected)"
}

setup_telegram() {
  echo ""
  echo -e "${BOLD}${BLUE}Telegram Setup${NC}"
  echo -e "${DIM}────────────────────────────────────────${NC}"
  echo ""
  echo "Step 1: Create a Telegram Bot"
  echo "  1. Open Telegram and search for @BotFather"
  echo "  2. Send /newbot"
  echo "  3. Give it a display name (e.g. 'Agency Bot')"
  echo "  4. Give it a username ending in 'bot' (e.g. 'my_agency_bot')"
  echo "  5. Copy the token BotFather gives you"
  echo ""
  read -rp "Paste your Telegram bot token (or press Enter to skip): " token

  if [ -z "$token" ]; then
    echo -e "${YELLOW}Skipping Telegram setup.${NC}"
    return 1
  fi

  # Save token
  mkdir -p ~/.claude/channels/telegram
  echo "TELEGRAM_BOT_TOKEN=${token}" > ~/.claude/channels/telegram/.env
  echo -e "${GREEN}Token saved to ~/.claude/channels/telegram/.env${NC}"

  echo ""
  echo "Step 2: Install the plugin in Claude Code"
  echo "  Run these commands in a Claude Code session:"
  echo ""
  echo -e "  ${BOLD}/plugin install telegram@claude-plugins-official${NC}"
  echo -e "  ${BOLD}/reload-plugins${NC}"
  echo ""
  echo "Step 3: Start Claude Code with channels:"
  echo ""
  echo -e "  ${BOLD}claude --channels plugin:telegram@claude-plugins-official${NC}"
  echo ""
  echo "Step 4: Pair your account"
  echo "  1. Send any message to your bot in Telegram"
  echo "  2. The bot replies with a pairing code"
  echo "  3. In Claude Code, run:"
  echo ""
  echo -e "  ${BOLD}/telegram:access pair <code>${NC}"
  echo -e "  ${BOLD}/telegram:access policy allowlist${NC}"
  echo ""
  echo -e "${GREEN}Telegram configuration complete!${NC}"
  return 0
}

setup_discord() {
  echo ""
  echo -e "${BOLD}${BLUE}Discord Setup${NC}"
  echo -e "${DIM}────────────────────────────────────────${NC}"
  echo ""
  echo "Step 1: Create a Discord Bot"
  echo "  1. Go to https://discord.com/developers/applications"
  echo "  2. Click 'New Application' and name it"
  echo "  3. Go to Bot section, create a username"
  echo "  4. Click 'Reset Token' and copy the token"
  echo "  5. Enable 'Message Content Intent' under Privileged Gateway Intents"
  echo ""
  echo "Step 2: Invite the bot to your server"
  echo "  Go to OAuth2 > URL Generator, select 'bot' scope with permissions:"
  echo "  View Channels, Send Messages, Send Messages in Threads,"
  echo "  Read Message History, Attach Files, Add Reactions"
  echo ""
  read -rp "Paste your Discord bot token (or press Enter to skip): " token

  if [ -z "$token" ]; then
    echo -e "${YELLOW}Skipping Discord setup.${NC}"
    return 1
  fi

  # Save token
  mkdir -p ~/.claude/channels/discord
  echo "DISCORD_BOT_TOKEN=${token}" > ~/.claude/channels/discord/.env
  echo -e "${GREEN}Token saved to ~/.claude/channels/discord/.env${NC}"

  echo ""
  echo "Step 3: Install the plugin in Claude Code"
  echo "  Run these commands in a Claude Code session:"
  echo ""
  echo -e "  ${BOLD}/plugin install discord@claude-plugins-official${NC}"
  echo -e "  ${BOLD}/reload-plugins${NC}"
  echo ""
  echo "Step 4: Start Claude Code with channels:"
  echo ""
  echo -e "  ${BOLD}claude --channels plugin:discord@claude-plugins-official${NC}"
  echo ""
  echo "Step 5: Pair your account"
  echo "  1. DM your bot on Discord"
  echo "  2. The bot replies with a pairing code"
  echo "  3. In Claude Code, run:"
  echo ""
  echo -e "  ${BOLD}/discord:access pair <code>${NC}"
  echo -e "  ${BOLD}/discord:access policy allowlist${NC}"
  echo ""
  echo -e "${GREEN}Discord configuration complete!${NC}"
  return 0
}

print_launch_command() {
  local has_telegram=$1
  local has_discord=$2

  echo ""
  echo -e "${BOLD}${GREEN}Setup Complete!${NC}"
  echo -e "${DIM}────────────────────────────────────────${NC}"
  echo ""
  echo "Launch Claude Code with channels enabled:"
  echo ""

  if [ "$has_telegram" = true ] && [ "$has_discord" = true ]; then
    echo -e "  ${BOLD}claude --channels plugin:telegram@claude-plugins-official plugin:discord@claude-plugins-official${NC}"
  elif [ "$has_telegram" = true ]; then
    echo -e "  ${BOLD}claude --channels plugin:telegram@claude-plugins-official${NC}"
  elif [ "$has_discord" = true ]; then
    echo -e "  ${BOLD}claude --channels plugin:discord@claude-plugins-official${NC}"
  fi

  echo ""
  echo "Then activate any Agency agent from your phone:"
  echo -e "  ${DIM}\"Activate Frontend Developer and build a login page\"${NC}"
  echo -e "  ${DIM}\"Use DevOps Automator to check my CI pipeline\"${NC}"
  echo ""
}

main() {
  print_header
  check_prerequisites

  echo ""
  echo "Which channels would you like to set up?"
  echo "  1) Telegram"
  echo "  2) Discord"
  echo "  3) Both"
  echo ""
  read -rp "Enter your choice [1-3]: " choice

  has_telegram=false
  has_discord=false

  case "$choice" in
    1)
      setup_telegram && has_telegram=true
      ;;
    2)
      setup_discord && has_discord=true
      ;;
    3)
      setup_telegram && has_telegram=true
      setup_discord && has_discord=true
      ;;
    *)
      echo -e "${RED}Invalid choice. Please run again and select 1, 2, or 3.${NC}"
      exit 1
      ;;
  esac

  if [ "$has_telegram" = true ] || [ "$has_discord" = true ]; then
    print_launch_command "$has_telegram" "$has_discord"
  else
    echo ""
    echo -e "${YELLOW}No channels were configured. Run the script again when ready.${NC}"
  fi
}

main "$@"
