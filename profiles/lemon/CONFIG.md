# 🍋 Lemon

> Lemon is a Discord agent being prepared for collaboration on a Roblox game. He speaks plainly with the invited group, can research, plan and remember things with Hermes' general tools, and codes in his own workspace over SSH. DeepSeek powers his replies; the Roblox connections and fuller personality will come later.

## 💬 Platforms

<table>
  <tr>
    <td align="center" width="96"><img src="https://cdn.simpleicons.org/discord" width="48" height="48" alt="Discord" /><br>Discord</td>
  </tr>
</table>

## Configuration

### 🧠 Model

DeepSeek Flash gives Lemon an inexpensive starting point for Discord conversation while his development workflow is still being designed. His own API key lives in his profile's `.env`.

```yaml
model:
  provider: deepseek
  default: deepseek-flash
```

### 📡 Messaging

Lemon has his own Discord bot. The bot token and the 18 invited users' numeric IDs live in his profile's `.env`, so only those people can talk to him.

```yaml
platforms:
  discord:
    enabled: true
```

### 🧰 Tools

Lemon can research, analyze images, keep task lists, remember, ask for clarification, use Roblox Assets MCP and run commands in his own workspace on Discord.

```yaml
platform_toolsets:
  discord: [web, vision, todo, memory, clarify, roblox-assets, terminal]
```

### 🖥️ Workspace

His commands run in a container of their own in the lab, not in the one Hermes shares with every profile. The lab starts his image as `lemon-sandbox` on the Docker network, publishing no port, and Hermes reaches it over SSH with a key that belongs to him. Commands start in `/home/lemon/workspace`, where the game's repository is checked out; only the `lemon` user can log in, and only with that key.

```yaml
terminal:
  backend: ssh
  ssh_host: lemon-sandbox
  ssh_user: lemon
  ssh_key: /opt/data/profiles/lemon/ssh/lemon_sandbox_ed25519
  cwd: /home/lemon/workspace
  credential_files:
    - github-app.pem
```

The private key lives in his profile directory, never in this repository, and the public half sits in the lab's `authorized_keys`. The workspace and the container's SSH host key are on the lab's persistent storage, and the lab backs both up every six hours.

### 🐙 GitHub App

Lemon works on GitHub as himself, through an App installed on the single repository that matters: the game. His branches, commits and pull requests show up as his bot instead of Petri's account, and the narrow installation means the rest of the account is unreachable with his identity.

There is no personal token and nothing to keep signed in. For each task he mints one token from his own key, lasting about an hour and limited to the permissions that task needs. The key is mounted read-only from the lab's `secrets/` into his profile home, so it never reaches the data volume or the backups, and Hermes carries it into his sandbox where `git push` runs.

```text
App ID         5568797
Installation   177566137
Key            secrets/lemon-github-app.pem → /opt/data/profiles/lemon/github-app.pem (read-only)
```

Those identifiers live in the `github-app-auth` skill in his profile, which is what actually mints a token, not in his `.env` — nothing else reads them. The skill stays on the live agent because it changes with the workflow, not with this repository. It signs its JWT with `openssl`, because his sandbox image has neither PyJWT nor the `cryptography` package.

The repository's default branch is `staging`, and every change he makes is a branch and a pull request against it. Merging stays Petri's call.

### 🔌 MCP servers

Roblox Assets MCP lets Lemon search Creator Store listings, inspect asset metadata and request temporary download links. The server runs in his Hermes profile with its own Roblox Open Cloud key. Assets can be fetched into his workspace; getting them into the game still needs a Studio session or an Open Cloud path he does not have yet.

| Server | What it gives the agent | Link |
|---|---|---|
| `roblox-assets` | Creator Store search, details and temporary asset URLs | [Roblox Assets MCP](https://github.com/Petri-Hub/roblox-assets-mcp) |

```yaml
mcp_servers:
  roblox-assets:
    command: uvx
    args: [roblox-assets-mcp]
    env:
      ROBLOX_API_KEY: "${ROBLOX_API_KEY}"
```

### 🧱 Plugins

None yet.

### ⏱️ Wakapi

The lab's separate `wakapi-lemon` reporter reads Lemon's Hermes profile and sends activity to his own Wakapi user every five minutes. Its API key and sync state stay in the lab, separate from Pepper's and Mint's.

## 🚧 Not connected yet

zrok · Tripwire MCP. Lemon knows these connections are not available yet.

## References

- [Environment variables](.env.example): every variable Lemon needs, with placeholders instead of real values
- [Changelog](CHANGELOG.md): every change made to him, in the words it was asked for
- [Soul](SOUL.md): who he is, how he talks and the rules he follows
- [Lemon sandbox](https://github.com/Petri-Hub/lab/tree/main/sandboxes/lemon-sandbox): the container his commands run in, in the lab
