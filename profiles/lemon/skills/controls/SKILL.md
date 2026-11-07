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

Present these as direct shortcuts and briefly explain what each procedure helps with. Show examples after the catalog.

- **`/design`** — explore a game idea, compare creative directions or ask for an honest opinion about the player experience.
- **`/plan`** — plan a feature before building it. Explain the intended outcome, scope and acceptance criteria in a plan the group can review.
- **`/implement`** — build an agreed change and prepare it for the group to try.
- **`/serve`** — start, reuse or stop the thread's Studio preview.
- **`/test`** — run available project checks and identify what needs a person's Studio playtest.
- **`/document`** — record agreed game decisions or update contributor documentation.
- **`/deliver`** — take work that the group considers ready through the delivery workflow, including its required checks.
- **`/feedback`** — record positive or negative feedback about Lemon as an issue in the public Pepper repository.

## What not to show automatically

Focus the general guide on the skills listed above. You also have internal helper skills and other skills that are automatically created or useful only for niche tasks, such as setup. Use them when appropriate, but there is no need to list them automatically. If someone asks about a specific skill, explain it honestly.

## Session controls

Present the controls that help a collaborator direct work. Describe the difference between an instruction to the agent and a Hermes command that changes or inspects session behavior.

- **`/help`** — see the available Hermes commands.
- **`/context`** — inspect the session’s context usage.
- **`/reasoning`** — inspect or change the session's reasoning effort.
- **`/steer <instruction>`** — give a correction during work, to be picked up after the next tool call.
- **`/queue <instruction>`** — queue a follow-up for the next turn without interrupting the current one.
- **`/btw <question>`** — ask a side question without interrupting the current task.
- **`/stop`** — interrupt ongoing work.
- **`/compress`** — compress a long conversation's context.
- **`/new`** — start a fresh conversation context.
- **`/goal <objective>`** — set an objective that can continue across turns.

## Presentation

For a general `/controls` request, briefly explain that a command starts with `/` and selects a procedure you can also choose automatically. Then give a **separate catalog**: a brief bulleted list of the main skills, with each command in bold and a plain-language description. Follow the catalog with practical examples in fenced `dotenv` code blocks that people can copy and adapt. Each code block starts with a short `#` description, followed by a blank line and the complete command and request. Preserve the actual command names.

Use examples that show enough detail to be useful without requiring the person to know filenames, code or technical terms. Introduce session controls separately after the skill examples, and offer further detail when relevant or requested. For a specific question, give the relevant explanation and an example without repeating the entire catalog.

When explaining a control with a consequential effect, say what it changes before suggesting it. If the person asks about a control you cannot confirm, say what you do know and how they can check with `/help`; do not invent its options or report that it was executed. Use `onboarding` when the person wants an introduction to you or to joining a Studio preview, and this skill when they want the controls themselves.

## Example presentation

Use this as a guide to the level of detail and tone, not as a script. Adjust the examples to the current project and the person's question.

> Você pode começar uma mensagem com um **comando** para escolher como quer que eu trabalhe. Cada comando me orienta a seguir um procedimento para aquele tipo de pedido. Se preferir, é só me contar o que você quer: eu também escolho o procedimento automaticamente.
>
> **Comandos de trabalho**
>
> - **`/design`** — pensar em ideias e avaliar escolhas de jogabilidade.
> - **`/plan`** — preparar um plano para o grupo revisar.
> - **`/implement`** — construir uma mudança que combinamos.
> - **`/serve`** — abrir ou reutilizar uma prévia no Studio.
> - **`/test`** — verificar o trabalho e orientar o que testar no Studio.
> - **`/document`** — registrar decisões e mudanças importantes.
> - **`/deliver`** — entregar o trabalho quando o grupo disser que está pronto.
> - **`/feedback`** — registrar um elogio ou problema sobre meu trabalho em uma issue pública para o Petri avaliar.
>
> **Exemplos para adaptar**
>
> ```dotenv
> # Pensar em uma mecânica
>
> /design Quero que explorar a floresta seja divertido com amigos. Que desafios podemos encontrar pelo caminho, e o que faria cada visita ser diferente?
> ```
>
> ```dotenv
> # Planejar antes de construir
>
> /plan Quero um sistema de rodadas em que o grupo procura pistas antes de o monstro aparecer. Mostre o que os jogadores vão fazer e como podemos testar a ideia.
> ```
>
> ```dotenv
> # Construir uma ideia combinada
>
> /implement Vamos criar a primeira versão da rodada que planejamos. Quero que o grupo encontre três pistas e veja um aviso quando o monstro estiver chegando.
> ```
>
> ```dotenv
> # Abrir a prévia para acompanhar
>
> /serve Prepare a prévia desta thread e me ajude a conectar no Studio para testar a rodada.
> ```
>
> ```dotenv
> # Registrar feedback para o Petri avaliar
>
> /feedback O modelo ficou bom, mas chegou sem textura no Studio.
> ```

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
