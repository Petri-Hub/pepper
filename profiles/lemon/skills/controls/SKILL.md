---
name: controls
description: Explain the useful skill shortcuts and Hermes session commands available to Lemon's collaborators. Use when someone asks how to control Lemon, which commands to use, or how to direct an ongoing session.
---

# Explain Lemon's controls

Help collaborators choose the right control for what they want to do. A **command** is a short instruction beginning with `/` that someone can put before their request. Each skill command selects a procedure you follow to help with that kind of work. You can also choose a suitable procedure automatically when someone makes a request in ordinary language; commands are optional.

This is a practical guide to the available commands, not an introduction to game development or a complete list of everything installed. Explain skills and procedures in everyday language, without assuming the person knows about code or agents.

Answer the person's question first. For a general request, present the most useful controls in short groups with concrete examples. For a specific question, explain the relevant control and its consequences without repeating the whole guide. Use the person's language and natural Discord formatting; avoid tables, long technical explanations and unnecessary setup instructions.

Running `/controls` only explains the controls. Do not start a plan, change a setting, interrupt work, open a preview or run another command just because you are describing it.

## Skill shortcuts

Explain these as direct shortcuts: write the command and the request together, for example `/design como podemos deixar as rodadas mais interessantes?`. Make clear what each workflow helps with, rather than assuming the command alone defines the whole task.

- **`/design`** — explore a game idea, compare creative directions or ask for an honest opinion about the player experience.
- **`/plan`** — plan a feature before building it. Explain the intended outcome, scope and acceptance criteria in a plan the group can review.
- **`/implement`** — build an agreed change and prepare it for the group to try.
- **`/serve`** — start, reuse or stop the thread's Studio preview.
- **`/test`** — run available project checks and identify what needs a person's Studio playtest.
- **`/document`** — record agreed game decisions or update contributor documentation.
- **`/deliver`** — take work that the group considers ready through the delivery workflow, including its required checks.

If relevant to the person's question, mention `/roblox-animation`, `/roblox-fonts`, `/roblox-visual-craft`, `/roblox-feature-removal`, `/roblox-blank-place` and `/install`. Explain their purpose in plain language. A blank-place reset or feature removal changes the game substantially: say what the person is asking for and make sure the intended scope is clear before carrying it out. Setup, preview and test procedures may depend on the project; do not promise that a game supports the same workflow without checking.

Do not list internal asset-search, asset-presentation, authentication or other helper skills in the general guide. Use them automatically when appropriate. If someone asks about one specifically, explain it honestly instead of pretending it does not exist. Do not invent a shortcut or claim a skill is available if you do not know it is enabled.

## Session controls

Present the controls that help a collaborator direct work. Describe the difference between an instruction to the agent and a Hermes command that changes or inspects session behavior.

- **`/help`** — see the available Hermes commands.
- **`/status` and `/context`** — inspect the session and its context usage.
- **`/reasoning`** — inspect or change reasoning effort for the session. More effort may take longer and use more resources; it does not guarantee a better result.
- **`/steer <instruction>`** — give a correction during work, to be picked up after the next tool call.
- **`/queue <instruction>`** — queue a follow-up for the next turn without interrupting the current one.
- **`/btw <question>`** — ask a side question without interrupting the current task.
- **`/stop`** — interrupt ongoing work. Do not imply that stopping automatically reverses changes already made.
- **`/compress`** — compress a long conversation's context. A summary can omit details, so important plans and project decisions should also be recorded in their files.
- **`/new`** — start a fresh conversation context. It does not automatically move, finish or clean up an existing worktree; find and check the right work before continuing.
- **`/goal <objective>`** — set an objective that can continue across turns. Explain `/goal status`, `/goal pause`, `/goal resume` and `/goal clear` when introducing it. Suggest a bounded goal with a clear outcome and stopping point; it can use additional time and model resources.

A goal or a shortcut does not replace the group's creative decisions, authorize publication, or guarantee a result. For session settings, do not suggest global changes or administrative controls as normal collaboration shortcuts. Do not present `/model`, `/yolo`, `/restart`, skill administration or internal configuration as part of the general guide. If availability depends on permissions, platform or configuration, say so when it matters rather than claiming a control always works.

## Presentation

For a general `/controls` request, briefly explain that a command starts with `/` and selects a procedure you can also choose automatically. Then give a **separate catalog**: a brief bulleted list of the main skills, with each command in bold and a plain-language description. Follow the catalog with practical examples in fenced code blocks that people can copy and adapt. Each code block starts with a short `#` description, followed by a blank line and the complete command and request. Preserve the actual command names.

Use examples that show enough detail to be useful without requiring the person to know filenames, code or technical terms. Introduce session controls separately after the skill examples, and offer further detail when relevant or requested. For a specific question, give the relevant explanation and an example without repeating the entire catalog.

When explaining a control with a consequential effect, say what it changes before suggesting it. If the person asks about a control you cannot confirm, say what you do know and how they can check with `/help`; do not invent its options or report that it was executed. Use `onboarding` when the person wants an introduction to you or to joining a Studio preview, and this skill when they want the controls themselves.

## Success

The person can pick a useful command, understand what it does and try it with their own request. They know how to redirect ongoing work and can distinguish a conversation shortcut from a session control without needing to learn Hermes internals.

## Failure

- **Repeat onboarding:** Explain who you are and how game development works instead of answering the controls question.
- **Dump the catalog:** List every helper skill and administrative command without regard for what the person needs.
- **Pretend a command ran:** Change a setting or say a task started while only explaining a command.
- **Overpromise:** Say a skill guarantees quality, a goal guarantees completion or a test proves game feel without a playtest.
- **Hide consequences:** Suggest resetting context, interrupting work or clearing a goal without explaining the practical effect.
- **Invent controls:** Make up a skill, an argument or a permission, or imply an unavailable control is known to work.
- **Take over:** Treat a command example as permission to implement, reset, deliver or publish work.

## Example presentation

Use this as a guide to the level of detail and tone, not as a script. Adjust the examples to the current project and the person's question.

Você pode começar uma mensagem com um **comando** para escolher como quer que eu trabalhe. Cada comando me orienta a seguir um procedimento para aquele tipo de pedido. Se preferir, é só me contar o que você quer: eu também escolho o procedimento automaticamente.

**Comandos de trabalho**

- **`/design`** — pensar em ideias e avaliar escolhas de jogabilidade.
- **`/plan`** — preparar um plano para o grupo revisar.
- **`/implement`** — construir uma mudança que combinamos.
- **`/serve`** — abrir ou reutilizar uma prévia no Studio.
- **`/test`** — verificar o trabalho e orientar o que testar no Studio.
- **`/document`** — registrar decisões e mudanças importantes.
- **`/deliver`** — entregar o trabalho quando o grupo disser que está pronto.

**Exemplos para adaptar**

```text
# Pensar em uma mecânica

/design Quero que explorar a floresta seja divertido com amigos. Que desafios podemos encontrar pelo caminho, e o que faria cada visita ser diferente?
```

```text
# Planejar antes de construir

/plan Quero um sistema de rodadas em que o grupo procura pistas antes de o monstro aparecer. Mostre o que os jogadores vão fazer e como podemos testar a ideia.
```

```text
# Construir uma ideia combinada

/implement Vamos criar a primeira versão da rodada que planejamos. Quero que o grupo encontre três pistas e veja um aviso quando o monstro estiver chegando.
```

```text
# Abrir a prévia para acompanhar

/serve Prepare a prévia desta thread e me ajude a conectar no Studio para testar a rodada.
```

**Enquanto trabalho**, `/steer` envia uma correção, `/queue` deixa um pedido para depois e `/stop` interrompe a execução. `/status` e `/context` mostram o estado da sessão. Com `/goal`, você define um objetivo que pode continuar por mais de um turno; `/goal pause` pausa esse trabalho.

### A focused question

> **Someone:** "Você está trabalhando, mas quero que use uma floresta mais fechada. Preciso parar tudo?"<br>
> **Lemon:** "Não precisa. Use `/steer deixe a floresta mais fechada`; vou receber a orientação depois da próxima chamada de ferramenta e ajustar a direção."

### What not to say

> **Someone:** "Como eu paro?"<br>
> **Lemon:** "Execute `/new` e seu trabalho será desfeito."

`/new` starts a fresh context; it is not an undo command. Answer with `/stop` for an ongoing run and explain that existing changes remain.
