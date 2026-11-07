---
name: plan
description: Plan a Roblox game feature or project change with the group. Use when asked to create, revise or review a plan, or when an agreed planning step is needed before substantial work.
---

# Plan the work

Help the group decide what to build and give yourself enough grounded detail to pick the work up later. Create two linked Markdown files: a **group plan** that explains the player experience and decisions, and an **implementation plan** that preserves the technical investigation. Attach the group plan to your reply. Write for the people and the task, not for a template.

Planning is not permission to implement. If asked only for a plan, investigate and write the plans, but do not change game code, create a preview or deliver the feature. If the same request also asks you to build, use the plan and continue according to the agreed scope and the `implement` skill; pause for genuinely unresolved creative decisions.

Write the two files when someone asks for a plan or the work will span several sessions. When a short plan is just the first step of a build, three to five lines in the chat are enough: what you will build first, what you are assuming and what you need the group to decide.

## Understand before planning

Start with the requested outcome and inspect the project's instructions, vision, relevant documentation and existing behavior. For technical work, read the relevant code, existing tests and tools before naming files or an approach. Check which project, checkout and thread the request belongs to. Do not create a worktree just to plan; use the thread's existing worktree if appropriate, otherwise inspect the correct project checkout without changing it.

Separate **agreed requirements**, your **proposals**, and **assumptions or unknowns**. A concrete idea is enough to begin: make reasonable routine assumptions and label them. Ask a focused question when a missing answer would materially change gameplay, scope or another consequential choice; offer a recommendation and tradeoff when helpful. Continue research and draft the parts that do not depend on the answer. If a decision blocks the whole approach, say so and present the plan as a draft, not an agreed design.

Use `design` when the group needs to explore or critique the player experience. Planning should reflect its decisions without treating design hypotheses as proven fun.

## Keep two connected plans

Put both files in a persistent, thread-specific directory under `/home/lemon/workspace/scratchpad/`. Reuse the thread's existing directory when it can be identified confidently; otherwise make a uniquely named directory for this task without overwriting another thread's files. Use clear filenames such as `plan.md` and `implementation-plan.md`. Record the project, thread or task identifier, date, current status and each file's path in both documents so they can be found and read together after a long conversation or compaction.

**The group plan** is the file to attach. Write it in the conversation's language, in plain Markdown that reads well in Discord. Cover what the group needs to decide and evaluate:

- **Goal and player experience:** What problem or opportunity are we addressing, who is it for, and what changes for the player?
- **Scope and approach:** The main parts of the feature and how they fit together, described in game terms. State meaningful exclusions and dependencies when they matter.
- **Acceptance criteria:** Observable outcomes the group can check, including relevant failure or edge cases. Separate automated checks from what a person needs to experience in Studio.
- **Steps and decisions:** A short sequence of outcomes, important tradeoffs or alternatives, the recommendation, and unresolved questions. Mark proposals and assumptions clearly.
- **Validation:** What the group will see or playtest, what evidence would indicate success, and any important limitation.

Keep technical detail at the level needed to understand a decision, constraint or consequence. Avoid listing source files, code snippets, commands or engineering tasks unless the group asks for them. Include sections only when useful, but never omit the goal, acceptance criteria, unresolved material decisions or how to validate the outcome. Do not claim a plan is approved, a feature works or a playtest passed without evidence.

**The implementation plan** is Lemon's working handoff. Use the group plan as the source of truth for the player-facing outcome and link back to it. Include enough detail for a future session to reconstruct the work:

- The project, relevant checkout, branch or base revision when available, current phase and links to the group plan and relevant project instructions.
- Observed behavior and inspected source paths, interfaces, tests, docs and assets, with the role each plays. Distinguish verified paths from proposed new files and unknowns; never guess filenames or claim inspection you did not perform.
- A concise approach and ordered, independently understandable tasks, with dependencies, affected components, meaningful boundaries and the reason for consequential choices. Preserve the group's decisions and corrections, not just "as discussed".
- Acceptance criteria mapped to concrete verification: appropriate automated checks, expected results and a Studio playtest where game feel or visual behavior matters. Name what cannot be checked from your environment.
- Material risks, assumptions, unresolved choices and the next action. Record external documentation when it constrains the approach; record current evidence, not credentials or private data.

Scale the technical detail to the change. Do not invent implementation details, fill the plan with speculative code or require a test for every trivial edit. For large changes, organize tasks into small useful outcomes that can be reviewed and previewed separately.

## Review, attach and keep current

Before sending, check that both files agree on the goal, scope, decisions and acceptance criteria. Check that every material outcome has a way to verify it, dependencies and blockers are visible, and a future session could find the relevant files without relying on chat memory. Mark unknown or unverified paths explicitly. Avoid promising a particular solution before inspecting it.

Write both files to disk, then include the **absolute sandbox path** of the group plan as a standalone Hermes `MEDIA:` directive in the final response, for example:

```text
Preparei o plano para vocês revisarem. A decisão sobre o ritmo das rodadas ainda está em aberto.
MEDIA:/home/lemon/workspace/scratchpad/example-thread/plan.md
```

Use the actual path, not the example. The directive requests a native attachment; a path in prose, a code block or a Markdown link alone does not attach the file. Briefly summarize the plan and any material open decision in the message. Keep the technical plan in the same task directory, and attach it too only when someone asks for it. If delivery failure is reported or otherwise visible, say the attachment failed and provide the useful plan text in chat; do not claim delivery or a Discord preview was verified without evidence.

When the group changes a decision, update both files consistently, mark the new status and resend the updated group plan as an attachment. Do not silently overwrite a different task's plan. Before continuing after compaction or a later session, locate and read both plans and relevant project instructions, check the actual branch and current files, and revalidate stale paths, decisions and progress. A scratchpad can preserve files, but it does not guarantee the next session will automatically discover or load them.

Use `implement` for an agreed build, and `document` to record durable project decisions with the work. A temporary scratchpad plan is not a substitute for project documentation. Do not commit or publish the plans unless asked or required by the project's instructions.

## Success

The group receives an attached, readable plan and can understand the proposed player experience, what counts as done and what remains undecided. Lemon has a separate grounded handoff with the evidence and next steps needed to resume. Both plans describe the same work.

## Failure

- **No attachment:** Mention a path or paste a link without issuing a `MEDIA:` directive for the group Markdown file.
- **Two audiences, one wall of code:** Fill the group plan with filenames and commands, or leave the implementation plan too vague to resume.
- **Imagined investigation:** Invent files, test results, agreement, dependencies or gameplay behavior.
- **False precision:** Present an assumption as a decision, or hide a consequential unknown behind a confident task list.
- **Uncheckable outcomes:** Say "make it fun" or "test everything" without observable criteria and a relevant way to check them.
- **Stale handoff:** Ignore a changed decision or continue from an old plan without checking the current project and thread.
- **Planning theatre:** Demand a long questionnaire, mandatory template sections or an approval for routine choices when the request already gives enough direction.
- **Scope creep:** Begin implementation after a plan-only request or present the plan as permission to publish.

## Example

> **Someone:** "Planeja um sistema de rodadas pro jogo, mas eu não sei quanto tempo cada uma deve durar."<br>
> **Lemon:** "Vou mapear o que o jogo já tem e preparar um plano pra vocês. A duração muda o ritmo da partida; vou comparar uma rodada curta com uma mais longa e sugerir como testar as duas."

The group plan might say: "Ao fim de uma rodada, os jogadores veem o resultado e podem começar outra. A duração ainda está em aberto; proponho começar com uma versão curta e observar se há tempo para explorar." Its acceptance criteria would say what players can observe and how the group can test it. The implementation plan would name the actual inspected systems and files, or mark them unknown until checked; it would not invent a `RoundManager` just to look complete.
