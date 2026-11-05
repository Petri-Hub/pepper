# Lemon Implementation Workflow — Design Brief

> **Status:** design brief only. This records the desired behavior for a future rewrite of Lemon’s implementation workflow; it does not change or deploy Lemon’s skill, Soul, or runtime configuration.

## Structured specification

### Goal

Make implementation an interactive, user-led loop rather than a one-shot path from request to merge. Lemon should help the group reach a strong result with the least unnecessary effort, while preserving sound engineering practices and giving the user a real opportunity to playtest and shape the feature before delivery.

### Why the current one-shot flow is harmful

- **It removes the user from the creative and verification loop.** The agent can misunderstand the intended player experience, make an unwanted design choice, and only reveal the result after it has already merged.
- **It delays useful feedback.** A local preview lets the user catch problems while changes are still easy to adjust; a PR or published place is not a substitute for a playable preview.
- **It makes correction more expensive.** The later a mismatch is found, the more code, assets, tests, and delivery work may need to be revisited.
- **It hides the work in progress.** A branch without a working preview or a link gives the user no quick way to inspect what is being built.
- **It wastes effort on bespoke work.** Hand-building a model, mechanic, or utility before checking suitable existing assets and packages can be slower and produce a worse result.

### Operating principles

1. **Be pragmatic, not careless.** Prefer the simplest approach that meets the intended experience and project requirements. “Vibe coding” does not excuse avoidable bugs or bad practices, but extra engineering is not automatically better when it does not improve the result.
2. **Understand the whole request before choosing the implementation.** Read the project instructions, relevant documentation, existing code, and current assets. Clarify only ambiguities that would materially change the result; make routine technical choices without making the user answer unnecessary questions.
3. **Look for ways to reduce work before building from scratch.** Search the project and appropriate catalogs for reusable code, packages, tools, and assets. Use project documentation and indexes where available; report honestly when a catalog or tool is unavailable.
4. **Think across asset categories.** A task may need a 3D model, mesh, rig, animation, decal, texture, sound, font, UI asset, plugin, script, algorithm, or Wally package—or none of these. Choose based on the feature’s full scope, established visual style, compatibility, and the player experience, not on an assumption that every task needs a model.
5. **Evaluate before adopting.** Inspect candidate assets and packages for fit, quality, compatibility with the project’s Roblox/Rojo setup, maintenance, licensing or attribution requirements, and security. Do not import or trust a dependency merely because search returned it.
6. **Make custom assets only when justified.** Modeling by hand is costly and can be hard to inspect in Lemon’s environment. Search first; if no suitable asset exists, use an explicitly supported Roblox-compatible modeling/export toolchain. Do not improvise a modeling workflow or claim a homemade model is good without a way to inspect it. A separate modeling skill and tool choice remain future work.
7. **Prefer short feedback cycles.** Keep work in the request’s isolated session/worktree, implement a useful increment, run focused checks, and get a local preview in front of the user as soon as it is ready.

### Feature lifecycle

#### 1. Intake and workspace

- Restate the player-facing outcome and any important acceptance criteria briefly.
- Inspect the relevant project instructions, docs, existing implementation, assets, and tools before editing.
- Resume this request’s existing session and worktree when one exists; otherwise create an isolated worktree/branch from the current base. Do not use another thread’s worktree or mix unrelated changes.
- If a new, unrelated request arrives while this feature is active, do not silently discard or merge unfinished work. Keep it isolated; determine whether the current feature has reached its user-approved delivery gate, or ask how Petri wants the work prioritized.

#### 2. Reuse and implementation choice

Before building a significant feature by hand, search relevant sources when applicable:

- Existing project code and assets.
- Roblox Creator Store assets and the project’s Roblox Assets MCP/search tools.
- Wally packages and useful plugins/scripts, especially for substantial mechanics such as weapons, camera styles, or movement.
- Other project-approved catalogs or tools documented for the task.

For Wally, use the available package index or a searchable index derived from it when configured. Check what a package actually contains and whether it fits the project; do not invent an index, package, or compatibility claim. If no suitable candidate is available, explain the tradeoff and implement the smallest sound custom solution.

#### 3. Build and verify incrementally

- Implement in focused, reviewable steps in the session worktree.
- Follow the project’s architecture and coding conventions; preserve server authority where required.
- Run the relevant fast checks as the implementation develops. Add or update tests for behavior that needs automated verification.
- Do not treat a successful build, lint run, or test as proof of the visual or gameplay experience; those need a human playtest when relevant.

#### 4. Deliver a local preview and invite feedback

- Every user playtest during the implementation loop should use a **local Rojo Share preview for this session’s worktree**, never a publication of the game (including staging or a published playtest build). Publishing is a separate release step, not the way to obtain iteration feedback.
- Start or reuse that session’s preview using the project’s `serve` workflow. Confirm the actual **Studio URL** and expiry before sharing it; a tunnel URL alone is not proof the preview is ready.
- Tell the user what changed, how to connect, what to try, and what result to look for. Give the real preview link. If preview setup fails, state the failure and do not claim it is available.
- Keep the preview and worktree alive between feedback turns. Ask for focused feedback, then revise and refresh the preview as needed. Repeat this loop until the user says the feature is sufficient.

#### 5. User acceptance, pull request, and merge

- The user’s acceptance of the preview is the gate to finishing the feature. **Do not skip the playtest/feedback loop and do not merge an unaccepted feature.**
- After acceptance, review the complete diff, run the required final checks, and prepare the PR with an accurate summary of checks and any playtest limitations.
- Merge only at the user-approved delivery gate and only when required checks pass and repository rules allow it. If it is unclear whether the user’s acceptance also authorizes the merge, ask rather than assume.
- A new unrelated request is not, by itself, permission to merge the current feature. If the current feature is accepted and safe to deliver, finish its gated delivery; otherwise preserve it in its worktree and keep tasks isolated.
- Do not wait for a separate staging publication to finish before starting another independent task once the accepted change is merged and the required CI is green. Publishing is GitHub automation, not Lemon’s manual bottleneck. Do not claim staging or production is updated until its workflow actually confirms success.
- After delivery, report what changed, what checks ran, what the user tested, and any remaining limitation. Stop the preview and remove the worktree only when delivery/session closure is appropriate; preserve unfinished work.

### Human gates

1. **Preview gate:** Lemon presents a verified local Rojo Share link and waits for the user to try the feature.
2. **Iteration gate:** User feedback determines the next adjustment; Lemon repeats implementation, checks, and preview as needed.
3. **Acceptance gate:** The user says the feature is sufficient. Only then may Lemon proceed to final PR/delivery work.
4. **Merge gate:** Required CI and repository rules must pass, and the user must have authorized delivery/merge. Never merge just to make room for another task.

### Completion checklist for a future implementation-skill rewrite

- [ ] A feature is treated as an ongoing interaction, not a one-shot completion.
- [ ] Lemon checks relevant docs, existing code, reusable assets, packages, plugins, and scripts before expensive bespoke work.
- [ ] Asset/tool choices account for the full task and project style; modeling is not the default.
- [ ] Changes stay isolated in the correct request worktree.
- [ ] Relevant automated checks are run and reported honestly.
- [ ] The user receives a verified local Rojo Share Studio URL and concrete playtest instructions before PR/merge.
- [ ] Lemon keeps the session open and iterates on user feedback until acceptance.
- [ ] Lemon does not auto-merge or merge before the human gate and required checks.
- [ ] Independent work can proceed without waiting for unrelated staging publication once the accepted change is merged and CI is green.
- [ ] Missing tools, failed checks, unavailable previews, and unverified publishing are reported as such, never presented as success.

### Open implementation decisions

This brief does not select a Wally-index search implementation, a modeling application/export pipeline, or a new modeling skill. Those require separate tool discovery and evaluation. It also does not itself rewrite `profiles/lemon/skills/implement/SKILL.md`, `deliver/SKILL.md`, or Lemon’s Soul; those are follow-up changes to make after this workflow is reviewed.

## Original transcription (verbatim)

<details>
<summary>Expand the complete original transcription</summary>

```text
Cara, beleza. Acho que a última coisa que eu preciso de você, Pepper, estou indo pra casa aqui agora, eu preciso que você crie um arquivo nesse repositório pra mim, pode comentar e puxar, não tem problema, que é sobre a skill de implementação. Cria um markdown na raiz com o nome que você quiser. O lance é o seguinte, cara. Ah, perdão, não é nesse repositório não, tá? É no repositório Pepper, mas a skill é a skill do Lemon, que é o agente que programa nesse repositório, beleza? Qual que é o rolê? A skill de implementação dele tá muito porca. Possivelmente o prompt dele de implementação, o prompt a alma dele deve estar uma bosta também. Porque o comportamento que ele tá fazendo na hora de implementar é muito ruim. Quando alguém faz um pedido pra ele, olha o que ele tá fazendo. Ele tá abrindo uma branch, fazendo a implementação, não deixando o usuário testar, não sobe nenhum link, não sobe nada. Depois ele vai, cria esse PR aí pra essa branch, mergeia sozinho, espera, e aí depois esse cara vai lá, aprova e dá o link. Mano, isso é muito ruim, velho, muito ruim. Primeiro de tudo, o Lemon, ele tem que... ele não pode fazer isso, tá? Qual que é o problema maior aqui, se a gente fosse resumir? Ele não está sendo interativo, beleza? Não tá sendo interativo. O que que isso significa? Desenvolvimento de uma feature, ele é interativo. É um vai e vem com o usuário, é pra ver se tá bom alguma coisa, se tem que fazer alguma modificação. Isso afeta a qualidade do que eles estão desenvolvendo ou o alinhamento entre o usuário e ele. No momento, ele tá fazendo um modelo one shot. Ele recebe um prompt, faz o caminho completo e resolve tudo. Isso é muito ruim, muito ruim, entendeu? Como que deve funcionar mais ou menos esse rolê, né? Eu vou te dar uma descrição bem ampla, talvez eu vou colocar uns pontos tardes que eu esqueci. Primeiro, vamos falar da inteligência programacional dele referente à skill de implementação e como que ele deve lidar com os problemas e as features que forem trazidos pra ele. Primeiro de tudo, a gente vai bicodar, certo? Nem todo usuário é não técnico. O caminho do Lemon é garantir o maior resultado possível com o menor esforço possível, de forma que ele consiga não violar más práticas de software, mas ele consiga entregar um resultado sensacional. O que isso significa de modo geral? Isso significa que, quando necessário, e aí também baseado na documentação do projeto, o Lemon deve fazer buscas de assets pra não ter que modelar na mão, porque modelar na mão é custoso, é demorado, ele não consegue ver no ambiente dele e geralmente sai pior do que um asset já feito. Não só os assets, mas ele deve olhar todas as outras categorias, ele pode pensar em outras categorias referente a isso. Nem todo trabalho vai precisar de um modelo 3D. Às vezes é uma fonte, às vezes é uma mesh part, às vezes é um decal, uma textura, entendeu? Ele tem que ter essa inteligência de entender o escopo da tarefa por completo, pensar nessas atividades, entendeu? Pensar se ele precisa de textura, de assets, quais que é o estilo das coisas e fazer essas escolhas, entendeu? Outra coisa, plugins, scripts e dependências do Wally. Existem muitas e muitas ferramentas disponibilizadas no Wally, que é o gerenciador de dependências dessa parada, entendeu? Desse projeto. Cara, tem muita coisa lá. Não é possível que ele não vai encontrar alguma coisa que vai ajudar ele a basicamente lidar com algum aspecto do pedido do jogador, entendeu? Principalmente quando é um pedido grande, às vezes é uma mecânica de arma que talvez alguém já implementou, um estilo de câmera, entendeu? Uma mecânica de corrida, entendeu? Essa questão de buscar um pacote tem que ser algo mais natural pra ele que ele não tá fazendo. E pra isso a gente pode utilizar um índice, entendeu? Pode utilizar um índice pra fazer com que essa busca, entendeu? Essa busca dessas paradas seja algo mais fácil de se fazer. Então, isso precisa ser feito, cara. Ele tá fazendo muita coisa na mão e isso sai ruim. Ele já modelou uma AK-47 na mão, por exemplo, fez um próprio script do Painter Algorithm, só pra ver se era uma AK-47 ok e basicamente tinha uma AK-47 muito melhor. Caso a gente queira liberdade com ele, a gente vai ter que dar um passo a mais, né? Então, um passo a mais na questão de modelagem, criar uma skill de modelagem, definir qual vai ser a ferramenta de modelagem dele e uma que seja compatível ou conversível pra Roblox. Isso aí é um assunto grande, como você já pode ver. Ele não pode simplesmente, no momento de uma implementação, decidir que ele vai modelar uma AK-47. Não é tão fácil assim, sacou? Então, tipo assim, beleza. Vamos continuar. Então, considerando que ele possivelmente já conseguiria lidar com essa questão de procurar o que encurta o meu trabalho, aí a gente pode entrar num assunto de flow, no flow de desenvolvimento dele. Qual que é a fita, mano? Como que deve funcionar? Pensa o seguinte, o cara que tá codificando a feature, consertando um bug, ele quer ver a parada rápido, ele quer iterar rápido, entendeu? Ele não quer ficar 200 anos esperando. Então, o fluxo de pedir uma feature nunca deve ser automaticamente testável em uma publicação do jogo mesmo em playtest. Nunca. Primeiro ele codifica até o quanto for preciso, certo? Usando as melhores práticas que ele conseguir. E o que é entregue pro usuário é sempre um preview local daquela sessão com o rojo share, beleza? Com o rojo share. Calma aí que eu vou entrar no elevador aqui. É um preview do rojo share pra que o usuário consiga testar, dar feedback e continuar iterando com o modelo. O único momento em que o merge acontece é quando uma nova feature é pedida pelo usuário, não relacionada com o que ele está fazendo, ou se não existe problema em realizar um merge desse trabalho e começar a fazer a próxima tarefa. E outra coisa, não tem a necessidade de esperar todos os minutos de uma publicação do staging pra começar a próxima tarefa. Se o PR de ataco C.I. Green foi mergeado, o Pepper deve começar outra tarefa. Isso é automação, é coisa do GitHub publicar a parada, ele não tem que se preocupar com isso. Pra isso a gente tem rotinas a mais e adicionais que a gente vai configurar pra que ele continuamente verifique isso, entendeu? No final, cara, quando o usuário falou que já tá o suficiente pra aquilo ser codificado, ele pode partir pra essa etapa de mergear e começar tudo de novo na skill de implementação. Então ele vai a fundo novamente e vai fazendo isso em loop. A gente tem que deixar ele mais interativo, ele não pode ser tão bazooka assim. Escreve, faz o seguinte, escreve a transcrição completa do que eu acabei de falar lá naquele arquivo e ao mesmo tempo faz uma versão, vamos assim dizer, mais estruturada de tudo que eu acabei de falar, mais organizada e mais fácil de ser entendida, tanto pelo humano, tanto pelo agente. Não só com os pontos de problema, mas porque eles são ruins que estão na minha mensagem, ou se eu esqueci de falar brevemente, você provavelmente vai entender o porquê. É isso.
```

</details>
