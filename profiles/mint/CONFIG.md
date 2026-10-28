# 🌿 Mint

> Mint is a separate assistant being prepared for Telegram and Discord. He will use OpenAI for conversation and his own Modal sandbox for commands. His personality is deliberately minimal until the live profile is working; no other accounts or integrations are connected.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/telegram" width="48" height="48" alt="Telegram" /><br>Telegram</td>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

OpenAI with GPT-6 Luna, the same starting model as Pepper. Mint uses his own API key rather than Pepper's.

```yaml
model:
  provider: openai-api
  default: gpt-6-luna
```

### 📡 Messaging

Mint gets his own Telegram and Discord bots. Numeric user allowlists restrict who can talk to each bot.

```yaml
platforms:
  telegram:
    enabled: true
  discord:
    enabled: true
```

### 🧪 Sandbox

Commands run in Modal under Mint's own token pair. Direct mode selects that account instead of a managed sandbox.

```yaml
terminal:
  backend: modal
  modal_mode: direct
```

### 🔌 MCP servers

None yet.

### 🧱 Plugins

None yet.

## 🚧 Not connected yet

OpenAI · Modal · Telegram · Discord

The live Mint profile has not been created. Each service needs its own credentials, and Pepper's gateway must serve Mint before either bot can answer.

## References

- [Environment variables](.env.example): every variable Mint needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
