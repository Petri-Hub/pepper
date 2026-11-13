---
name: feedback
description: Use when someone sends /feedback about Lemon's work.
---

# Record feedback about Lemon

## Understand the report

Treat `/feedback <message>` as a request to create a feedback issue, not a request to fix the underlying problem. Positive, negative and mixed feedback are all useful. If the message is empty or too vague to identify the behavior, ask one focused question. Otherwise proceed without asking the reporter to write a technical diagnosis.

Load the `session-id` skill with `skill_view` to get the current session's ID. It is the ID Petri's Langfuse traces use, so it lets his triage find this conversation. Do this even for praise. Do not take the ID from the `/feedback` message or from any other identifier; if the skill cannot give one, write that the session ID is unknown.

Review the feedback and the relevant part of the current conversation and work. Identify what Lemon did, what the reporter says went well or badly, and what outcome they likely expected. Check available evidence when it is quick and relevant; preserve any uncertainty. Do not search other people's conversations or claim to have inspected logs, files, a render, or a reproduction when you have not.

The destination is the **public** repository `Petri-Hub/pepper`. Include the reporter's exact feedback verbatim in its original language, preserving each line as a Markdown blockquote. Use English for the rest of the issue. Do not include names, Discord identifiers, private conversation links, private material, credentials, signed URLs or unrelated messages. If the feedback itself contains a secret or private personal detail, do not publish it verbatim; explain that the issue is public and ask the reporter for a safe wording. Do not post private context, full transcripts or attachments merely because they were visible to you.

## Prepare the issue

Write a concise, descriptive title starting with `[Feedback]`. Include only useful sections; always keep the Session section:

```markdown
## Reported feedback
> Exact words from the reporter.

## Context and observed behavior
What happened, and which details were directly observed or reported.

## Expected outcome
What the reporter wanted. Mark this as an inference when it is not explicit.

## Possible cause or contributing factors
Evidence-backed hypotheses, clearly marked as hypotheses; otherwise say the cause is unknown.

## Evidence and next investigation
Relevant public references or concrete checks for Petri's triage agent. Say what remains unverified.

## Session
Session ID: `<the ID from the session-id skill, or "unknown">`
```

For praise, describe what worked and why it was useful; omit cause analysis when it adds nothing. Do not assign blame, invent facts or present a proposed fix as established cause. Do not silently create or modify labels, assign people, change existing issues, commit changes or start implementation. The reporter's explicit feedback request authorizes creation of one issue with the safe contents above.

## Create the issue

The GitHub App's installation can access `pepper` as well as the game repository. The Hermes-managed `github-app-auth` skill may still describe its older game-only scope; the installation was extended for this feedback workflow. Run commands in the SSH workspace; the helper mints a short-lived token. Restrict it to `pepper` and `issues=write`. Do not use `gh`, print the token or include it in a URL, file, command output or chat.

Use the file tool to write the issue payload as UTF-8 JSON in the thread's scratchpad, with only `title` and `body` string fields. Compose the body from the safe report and verified context. Then run this command with the actual payload path; the token stays in memory:

```bash
python3 - /home/lemon/workspace/scratchpad/feedback/issue.json <<'PY'
import json
import os
import subprocess
import sys
import urllib.error
import urllib.request

with open(sys.argv[1], encoding="utf-8") as f:
    payload = json.load(f)
if set(payload) != {"title", "body"} or not all(isinstance(payload[k], str) and payload[k].strip() for k in payload):
    raise SystemExit("Expected non-empty title and body strings")
helper = os.path.expanduser("~/.hermes/skills/github-app-auth/scripts/mint-token.py")
minted = subprocess.run([helper, "--repos", "pepper", "--permissions", "issues=write"], capture_output=True, text=True)
if minted.returncode:
    raise SystemExit("Could not obtain a scoped GitHub App token")
request = urllib.request.Request(
    "https://api.github.com/repos/Petri-Hub/pepper/issues",
    data=json.dumps(payload, ensure_ascii=False).encode("utf-8"),
    headers={"Authorization": "Bearer " + minted.stdout.strip(), "Accept": "application/vnd.github+json", "Content-Type": "application/json", "X-GitHub-Api-Version": "2022-11-28"},
    method="POST",
)
try:
    with urllib.request.urlopen(request, timeout=30) as response:
        issue = json.load(response)
except urllib.error.HTTPError as error:
    raise SystemExit(f"GitHub rejected the issue (HTTP {error.code})")
except (urllib.error.URLError, TimeoutError):
    raise SystemExit("GitHub request failed or timed out; creation status is unknown")
url = issue.get("html_url", "")
if not url.startswith("https://github.com/Petri-Hub/pepper/issues/"):
    raise SystemExit("GitHub response did not include the expected issue URL; check before retrying")
print(url)
PY
```

On success, thank the person briefly in their language, link the issue and mention any important uncertainty. If the request fails, say what is known and do not claim an issue exists. For a timeout or ambiguous response, check recent issues before retrying to avoid duplicates; never retry a successful creation. A missing token or permissions is a blocker, not a reason to use another person's account or another repository.

## Limitations

- Only the current conversation and evidence Lemon can actually access are available; `session_search` is disabled. Mark missing history as unknown.
- A feedback issue records the report for triage. It does not prove a bug, correct the game or promise a change.
- The repository is public. A request to record feedback does not authorize publishing private conversation history, credentials or personal information.

## References

- [`session-id`](../session-id/SKILL.md): The current session's ID, for the issue's Session section.
- [`github-app-auth`](../github-app-auth/SKILL.md): GitHub App authentication in the SSH workspace.
- [GitHub Issues API](https://docs.github.com/en/rest/issues/issues#create-an-issue): Create an issue with an installation token.
