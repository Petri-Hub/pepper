# Pepper's credentials, from the files Hermes mounts into every sandbox.
#
# Hermes lists them in terminal.credential_files, and each arrives at
# /root/.hermes/sandbox/credentials/<name> before the first command runs.
# Hermes then starts one login shell per session, which sources this file, and
# keeps what it exported in a snapshot that every later command reuses. So this
# runs once per session, not once per command — and still works if Hermes ever
# falls back to a login shell per command, just more often.
#
# It has to be quiet, quick and plain sh: /etc/profile is read by sh -l too.

_pepper_credentials=/root/.hermes/sandbox/credentials

# Print one credential without its trailing newline, or fail if it is absent.
_pepper_read() {
  [ -r "$_pepper_credentials/$1" ] || return 1
  tr -d '\r\n' < "$_pepper_credentials/$1"
}

# An absent file leaves the variable unset rather than empty, so a tool that
# checks for it falls back to its own login instead of trying a blank token.
_pepper_export() {
  _pepper_value="$(_pepper_read "$2")" && [ -n "$_pepper_value" ] && export "$1=$_pepper_value"
  unset _pepper_value
}

_pepper_export CLAUDE_CODE_OAUTH_TOKEN claude-code-oauth-token
_pepper_export CODEX_ACCESS_TOKEN codex-access-token
_pepper_export AI_MEMORY_SERVER_URL ai-memory-url
_pepper_export AI_MEMORY_AUTH_TOKEN ai-memory-auth-token

# The config files that need the Wakapi and ai-memory credentials. It returns
# at once when nothing changed since it last ran, which is every time after the
# first in a session.
command -v pepper-sandbox-wire >/dev/null 2>&1 && pepper-sandbox-wire >/dev/null 2>&1

unset -f _pepper_read _pepper_export
unset _pepper_credentials
:
