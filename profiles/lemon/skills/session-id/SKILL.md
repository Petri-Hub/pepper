---
name: session-id
description: Give the ID of the current Hermes session, the one Petri's Langfuse traces are grouped by. Load it with skill_view when a report needs to point to this conversation. People do not invoke it directly.
---

# Current session ID

The ID of the current Hermes session is:

`${HERMES_SESSION_ID}`

Petri's Langfuse traces are grouped by this ID, so it lets him find this conversation's traces. It is an opaque identifier and is safe to include in a public issue.

## Using it

- Copy the ID exactly as shown. Do not shorten it, guess it, or use any other identifier from the conversation, such as a channel, thread or message ID.
- If the line above shows a dollar sign and braces around the words HERMES_SESSION_ID instead of an ID, the ID is not available. Say the session ID is unknown; do not make one up.
- If the tool answers that you already viewed this skill, use the ID from that earlier view.
- A long conversation can move to a new session when its context is compressed. Load this skill again at the time you need the ID, so it names the current session.
