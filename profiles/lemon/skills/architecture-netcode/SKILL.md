---
name: architecture-netcode
description: Use when state or input crosses server and client.
---

# Server and client: who decides what

Start with `architecture`. This skill covers the line between the two programs a Roblox game runs: the **server**, one copy that every player shares, and each player's **client**. Most lag players notice is not the amount of server code. It is waiting for the server before something they did shows on screen. A short rule keeps both problems away: **the server is the judge, the client is the performer.**

## Who owns what

| The server owns (the judge) | The client owns (the performer) |
|---|---|
| Values other players see or that must persist: health, stamina, inventory, currency | Input, camera, animations, effects, sound, the HUD |
| Damage and who got hit | Starting the swing animation the instant the button is pressed |
| Whether an action is allowed (enough stamina, not stunned) | Predicting the result, and correcting when the server disagrees |

A value the client may not change belongs in a server feature. A value only the client draws belongs in a client feature. A rule that both need, like how much a swing costs, is a number in the feature's shared `Config`.

## How a request travels

```text
client                     server                          every client
  press key ──intent────►  validate, decide  ──attribute──►  read, draw
  predict (feel first)     change the state                  correct if it differs
```

1. **The client sends intent**, never a result. "I want to sprint", not "my speed is 24".
2. **The server validates** the intent and decides. It checks the argument's type, whether the action is allowed, and the rate.
3. **The server replicates state** as an attribute on the character. The client reads it and draws.
4. **The client predicts** by starting its own feedback immediately, and lets the replicated state correct it.

All four steps are in the example. The server half:

```lua
-- src/server/player/sprint/init.luau
intent.OnServerEvent:Connect(function(player: Player, wantsSprint: unknown)
	local character = player.Character
	if not character or typeof(wantsSprint) ~= "boolean" then
		return -- never trust the shape of what a client sends
	end
	if wantsSprint then
		start(character)
	else
		stop(character)
	end
end)
```

And the client half, predicting first and correcting from the replicated attribute:

```lua
-- src/client/player/sprint/init.luau
local function request(sprinting: boolean)
	intent:FireServer(sprinting)
	showFieldOfView(sprinting) -- prediction: no waiting for the server
end

character:GetAttributeChangedSignal(Config.Attribute):Connect(function()
	showFieldOfView(character:GetAttribute(Config.Attribute) == true) -- correction
end)
```

## Choosing how to send it

| You need | Use |
|---|---|
| The client to draw a value the server owns (stamina, "is sprinting") | An attribute on the character holding a primitive. Read it with `GetAttributeChangedSignal`, never in a loop |
| The client to ask the server to do something | A `RemoteEvent` the server creates, named for the intent |
| A one-time effect on every client (a hit flash) | The server fires the event to the clients, or sets an attribute they react to |
| The server to know an answer immediately | Avoid a `RemoteFunction` that makes the server wait for a client; ask through an event and use the reply later |

Replicate on a tick, not per frame. The example regenerates stamina ten times a second. Firing a remote or setting an attribute every frame for every character adds up fast.

## How much to trust the client

Match the trust to the game, and say what you chose in one sentence as a decision.

- **A co-op game with friends:** trust the client for feel. A swing starts instantly, and a hit the client reports can be accepted after a cheap sanity check, such as range. Keep the server authoritative for state: health, stamina, damage numbers. Cheating costs little here and lag costs a lot.
- **A public or competitive game:** treat every client value as a claim to verify. Recompute hits on the server and limit how often each remote may fire.

Whichever you choose, validate the type and range of every remote argument, and never let a client write a value that other players depend on.

## What not to worry about

- Holding stamina or health on the server. It is a number, and attributes replicate it cheaply.
- Walking. Each player's client simulates its own character's movement, so it stays smooth. A walk speed the server sets arrives a moment later, which is fine.

## What does cause lag

- Waiting for the server before starting your own feedback. Predict instead.
- A remote or attribute write on every frame, for many characters.
- A server loop on every frame that touches many instances. Use one loop on a tick, as `player/stamina` does.

## Failure modes to avoid

- **Client-decided outcomes.** The client sends "I did 50 damage" or "I have 100 stamina" and the server believes it.
- **The silent client.** Waiting for the server's reply before the player sees any reaction to their own input.
- **Unvalidated remotes.** Using an argument without checking its type, or letting one remote be fired a thousand times a second.
- **Per-frame replication.** Writing an attribute inside a `RenderStepped` or `Heartbeat` loop for every character.
- **Server and client both owning a rule.** "Is the player armed?" decided in two places, each in its own way. The server writes it as an attribute and the client reads it.
