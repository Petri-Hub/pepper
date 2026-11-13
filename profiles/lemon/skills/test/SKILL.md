---
name: test
description: Use when checking that a change builds, lints and passes.
---

# Test the project

## Checks

Run checks from the thread's worktree after its tools and dependencies are installed. Match the checks to the stage of the work:

- **Draft or feedback round:** the quickest check that shows the change builds, usually `make build`, plus `make lint`, and `make check-architecture` when the project has it, when you changed logic or moved files. Don't run the full set or Open Cloud tests for every round.
- **Finish and delivery:** the checks relevant to the change, including Open Cloud tests when behavior changed. Fix failures before delivery.

These commands are defined by the project's `Makefile`:

```sh
# Check Luau formatting.
make format-check

# Check the Luau source and tests.
make lint

# Check the architecture: requires resolve, features stay separate, modules stay small.
make check-architecture

# Build the development place.
make build
```

`make check-architecture` fails when a `require` points at nothing, when a source file sits outside `src/server`, `src/client` and `src/shared`, or when a feature reaches into another's internals. Fix the code; do not edit `architecture.toml` to silence it. For formatting changes, `make format-apply` updates Luau files in the current worktree. Review the resulting diff. These checks do not run the game or prove a feature works in Studio.

## Open Cloud

The project's Jest suite runs in Roblox Open Cloud:

```sh
# Run the automated tests in Open Cloud.
make test-on-ocale
```

Check that the test settings are present without printing their values. Open Cloud runs use a shared test place and limited resources. Before starting a local run, check whether another run is using it; coordinate with the group if the state is unclear. GitHub's CI concurrency does not coordinate local runs with CI. Run them at the finish rather than in every feedback round, avoid unnecessary duplicate runs, and do not skip the required PR checks when the project has them. A project without a GitHub repository has no CI, so your local checks are the only ones: run the full set before delivery.

## Studio

The sandbox cannot run Studio. Ask a collaborator to playtest visual, audio or interactive changes in the thread's preview. Explain what to check and what result you expect. Do not claim the playtest passed until the person confirms it.

## Results

Report which checks passed, failed or could not run, including a useful error summary without credentials. If a check fails, investigate and retry when appropriate. If it remains blocked, explain what is needed; never present a skipped or unavailable check as a pass.
