---
name: deliver
description: Use when the group says finished work can ship.
---

# Deliver a change

## Acceptance

Deliver only after someone in the thread has said the change is finished for now. Most of the group doesn't know GitHub, so if nobody has said it yet, ask in plain words, for example "Posso considerar pronto e mandar pro jogo?", and wait. Passing checks, a working build or your own review are not the group's acceptance.

## Prepare

Use the workspace layout, Git and project instructions to confirm the project, the thread's worktree, its branch and the project's base branch. Review the diff, keep unrelated work out, and use the `test` and `document` skills where relevant. Address failed checks already run and report anything that could not be verified. The pull request's required CI checks run after the PR is opened.

Commit with a Conventional Commit and use the GitHub App authentication skill. Push the feature branch and open a pull request to the project's base branch when the change is close to ready. Do not push to a protected branch or force-push. Describe what changed, the checks performed and any remaining playtest limitations.

## Local projects

A game made with `create` has no GitHub repository until Petri creates one: `git remote -v` shows nothing. Deliver it locally instead of through a pull request:

1. Commit the thread's work on its branch with a Conventional Commit.
2. Run the full checks with the `test` skill, including `make test-on-ocale` when behavior changed. There is no CI to catch what you skip.
3. In the primary checkout under `projects/`, which stays on `main`, merge the thread's branch with `git merge --no-ff <branch>`. If `main` moved, bring the branch up to date in its worktree and check again first.
4. Tell the thread what was merged and which checks passed. There is no publishing; the group sees the change through a `serve` preview.

Then clean up as described in After merge. Never add a remote or create a GitHub repository yourself.

## Checks

Watch the required checks on the pull request's current changes. If more work is needed after opening it, close the PR while making and checking the changes, then reopen it when ready. Reopening triggers checks again. If the base branch changed, bring the feature branch up to date without discarding work or bypassing the project's rules, then wait for the checks again.

Merge the PR yourself once the group has accepted the change, the required checks pass on the final changes and GitHub reports it meets the branch rules. No code review is needed. If a required check fails, remains pending or the merge is blocked, explain the problem and resolve it before merging. Do not bypass branch protection or treat a skipped check as proof that it passed.

## After merge

Check whether the merge triggered a publishing workflow and report its actual result to the thread. Explain any remaining playtest limitations. Once the correct PR or local merge is in, stop this thread's preview and remove its worktree. First check for uncommitted, untracked or unpushed work; preserve unexpected leftovers and tell Petri before removing anything. Do not stop or remove another thread's work.
