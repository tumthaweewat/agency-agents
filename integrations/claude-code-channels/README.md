# Claude Code Channels Integration

Control your Agency agents from **Telegram** and **Discord** using
[Claude Code Channels](https://code.claude.com/docs/en/channels). Send messages
from your phone and Claude replies through the same chat while running against
your local files with full agent access.

> **Requirements**: Claude Code v2.1.80+, [Bun](https://bun.sh) runtime,
> claude.ai login (API keys not supported).

## Quick Setup

Run the interactive setup script:

```bash
./integrations/claude-code-channels/setup.sh
```

Or follow the manual steps below.

---

## Telegram Setup

### 1. Create a Bot

1. Open [BotFather](https://t.me/BotFather) in Telegram
2. Send `/newbot`
3. Give it a display name (e.g. "My Agency Bot") and a username ending in `bot`
4. Copy the token BotFather returns

### 2. Install the Plugin

In Claude Code:

```
/plugin install telegram@claude-plugins-official
/reload-plugins
```

### 3. Configure Your Token

```
/telegram:configure <your-bot-token>
```

This saves the token to `~/.claude/channels/telegram/.env`.

### 4. Start with Channels Enabled

```bash
claude --channels plugin:telegram@claude-plugins-official
```

### 5. Pair Your Account

1. Open Telegram and send any message to your bot
2. The bot replies with a pairing code
3. In Claude Code, run:

```
/telegram:access pair <code>
/telegram:access policy allowlist
```

Now you can message your bot from anywhere and Claude will respond using your
local environment with all Agency agents available.

---

## Discord Setup

### 1. Create a Bot

1. Go to the [Discord Developer Portal](https://discord.com/developers/applications)
2. Click **New Application** and name it
3. Go to **Bot** section, create a username
4. Click **Reset Token** and copy the token
5. Under **Privileged Gateway Intents**, enable **Message Content Intent**

### 2. Invite the Bot to Your Server

Go to **OAuth2 > URL Generator**, select the `bot` scope, and enable:

- View Channels
- Send Messages
- Send Messages in Threads
- Read Message History
- Attach Files
- Add Reactions

Open the generated URL to add the bot to your server.

### 3. Install the Plugin

In Claude Code:

```
/plugin install discord@claude-plugins-official
/reload-plugins
```

### 4. Configure Your Token

```
/discord:configure <your-bot-token>
```

This saves the token to `~/.claude/channels/discord/.env`.

### 5. Start with Channels Enabled

```bash
claude --channels plugin:discord@claude-plugins-official
```

### 6. Pair Your Account

1. DM your bot on Discord
2. The bot replies with a pairing code
3. In Claude Code, run:

```
/discord:access pair <code>
/discord:access policy allowlist
```

---

## Using Both Channels Together

Start Claude Code with both channels enabled:

```bash
claude --channels plugin:telegram@claude-plugins-official plugin:discord@claude-plugins-official
```

## Using with Agency Agents

Once channels are set up, you can activate any Agency agent from your phone:

**Telegram/Discord message:**
> Activate Frontend Developer and help me build a React login component.

**Telegram/Discord message:**
> Use the DevOps Automator agent to check my CI pipeline status.

Claude processes the request using your local files and replies back through the
same chat.

## Tips

- **Permission prompts**: Claude pauses silently on permission prompts. If
  you're away from the terminal, the session waits until you approve locally.
- **Session must be open**: Events only arrive while Claude Code is running.
  Use a persistent terminal or background process for always-on setups.
- **Fakechat for testing**: Try the localhost demo first:
  ```
  /plugin install fakechat@claude-plugins-official
  claude --channels plugin:fakechat@claude-plugins-official
  ```
  Then open http://localhost:8787 to test.

## Enterprise / Team Plans

Channels are disabled by default on Team and Enterprise plans. An admin must
enable them at **claude.ai > Admin settings > Claude Code > Channels** or by
setting `channelsEnabled: true` in managed settings.
