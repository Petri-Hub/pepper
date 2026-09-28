#!/usr/bin/env bash
# Everything about the three coding agents that can be decided without a
# secret: the WakaTime integrations, and the one place their clock readings
# go. What does need a secret — which Wakapi, which ai-memory, whose tokens —
# is pepper-sandbox-wire's job at runtime, from sandbox/credentials.
#
# All three agents report through the same wakatime-cli --sync-ai-activity,
# which reads each agent's own transcripts (Claude Code, Codex and OpenCode are
# among the formats it knows) and sends what it finds. They differ only in what
# calls it: a plugin for Claude Code, a managed hook for Codex, a plugin for
# OpenCode.

source "$(dirname "$0")/lib/common.sh"

require_version WAKATIME_CLAUDE_PLUGIN_VERSION "${WAKATIME_CLAUDE_PLUGIN_VERSION:-}"

# --- wakatime-cli, where the plugins look for it ----------------------------
# The Claude Code plugin looks in ~/.wakatime and downloads the CLI there when
# it finds nothing, on the first hook of every fresh sandbox. Pointing it at
# the pinned binary already in the image skips that download.
mkdir -p /root/.wakatime
ln -sf /usr/local/bin/wakatime-cli /root/.wakatime/wakatime-cli-linux-amd64
ln -sf /usr/local/bin/wakatime-cli /root/.wakatime/wakatime-cli
log "linked ~/.wakatime to /usr/local/bin/wakatime-cli"

# --- Claude Code: the official plugin ---------------------------------------
# A marketplace can't be added at a ref, so the plugin installs whatever its
# repository holds today. The check below turns that into a pin: an upstream
# release fails the build until compose.yml agrees with it.
claude plugin marketplace add wakatime/claude-code-wakatime >/dev/null
claude plugin install claude-code-wakatime@wakatime >/dev/null
installed="$(jq -r '.plugins["claude-code-wakatime@wakatime"][0].version // empty' /root/.claude/plugins/installed_plugins.json)"
[ "$installed" = "$WAKATIME_CLAUDE_PLUGIN_VERSION" ] \
  || die "claude-code-wakatime installed $installed, but compose.yml pins $WAKATIME_CLAUDE_PLUGIN_VERSION"
log "claude-code-wakatime $installed installed"

# The plugin syncs at most once a minute per session, and its first sync runs
# when the prompt is submitted, before there is anything to send. On a desktop
# the next session's first sync picks up the rest; a sandbox running short
# `claude -p` jobs may never have a next session, so the end of each one would
# be lost. This hook syncs once more when the session ends, and is not async,
# so Claude Code waits for it before exiting.
settings=/root/.claude/settings.json
jq '.hooks.SessionEnd += [{
      matcher: "",
      hooks: [{
        type: "command",
        command: "wakatime-cli --sync-ai-activity --plugin \"claude-code/${PEPPER_SANDBOX_CLAUDE_CODE:-unknown} pepper-sandbox/1\" --project-folder \"${CLAUDE_PROJECT_DIR:-$PWD}\" >/dev/null 2>&1 || true",
        timeout: 30
      }]
    }]' "$settings" > "$settings.tmp"
mv "$settings.tmp" "$settings"
log "claude code: SessionEnd hook syncs wakatime-cli one last time"

# --- Codex: a managed hook --------------------------------------------------
# Codex asks a person to trust every new hook before it runs, and nobody is
# there to answer in a sandbox. Hooks in /etc/codex/managed_config.toml are an
# administrator's and skip that review, so both this one and ai-memory's (moved
# here by pepper-sandbox-wire) live there. This file is the part known at build
# time; the wire script appends to a copy of it.
mkdir -p /etc/pepper-sandbox
cat > /etc/pepper-sandbox/codex-managed-base.toml <<'TOML'
[[hooks.Stop]]
matcher = ""

[[hooks.Stop.hooks]]
type = "command"
command = "wakatime-cli --sync-ai-activity --plugin 'codex pepper-sandbox/1' --project-folder \"$PWD\" >/dev/null 2>&1 || true"
TOML
mkdir -p /etc/codex
cp /etc/pepper-sandbox/codex-managed-base.toml /etc/codex/managed_config.toml
log "codex: wakatime Stop hook in /etc/codex/managed_config.toml"

# --- OpenCode: a plugin -----------------------------------------------------
# OpenCode loads every file in ~/.config/opencode/plugins/. This one waits for
# a session to go idle — the end of a turn — and hands the transcripts to
# wakatime-cli without waiting for it, so a slow Wakapi never slows a reply.
mkdir -p /root/.config/opencode/plugins
cat > /root/.config/opencode/plugins/wakatime.ts <<'TS'
import type { Plugin } from "@opencode-ai/plugin";
import { spawn } from "node:child_process";

export const WakaTime: Plugin = async ({ directory }) => ({
  event: async ({ event }) => {
    if (event?.type !== "session.idle") return;
    const child = spawn(
      "wakatime-cli",
      ["--sync-ai-activity", "--plugin", "opencode pepper-sandbox/1", "--project-folder", directory],
      { stdio: "ignore", detached: true },
    );
    child.on("error", () => {});
    child.unref();
  },
});

export default WakaTime;
TS
log "opencode: wakatime plugin in ~/.config/opencode/plugins"

# --- Leave no identity behind -----------------------------------------------
# Running claude above made it write an install identity to ~/.claude.json, a
# userID and machineID every sandbox would otherwise share, plus a backup of
# that file. Each sandbox should start as a fresh install and make its own.
jq 'del(.userID, .machineID, .firstStartTime, .firstStartVersion)' /root/.claude.json > /root/.claude.json.tmp
mv /root/.claude.json.tmp /root/.claude.json
rm -rf /root/.claude/backups /root/.npm/_logs
log "cleared the build's Claude Code identity"
