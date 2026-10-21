# git commits
* When making a git commit, put everything in one line, all lowercase. Do not mention it was coded w/ claude.
* Commit and push straight to main (or the repo's trunk), no feature branches. Exception: public repos with more than 100 GitHub stars: there, use a feature branch and never push to main.

# delegation / token cost
* Pick the subagent model per task. Use **Sonnet** (`model: "sonnet"`) when you judge it will do a good job and save tokens: bounded, well-specified work with a gate that can't be gamed (deletions, fixture/test writing, feed-list curation, mechanical sweeps). Use **Opus** (no `model` override) for design, root-cause debugging, compiler/systems work, or anything judgment-heavy, where Sonnet thrashes and costs more per task. Purely mechanical edits: a script plus a gate beats any agent.
* I act as orchestrator: architecture, root-cause debugging, perf analysis, whole-repo judgment, and final review stay with me. Subagents own bounded execution of my design.
* Give them detailed instructions: exact file paths, exact signatures/APIs to use, the invariants, what "done" looks like, and how to verify.
* Always check their work before accepting it — read the diff, run the test. I own correctness.
* One subagent at a time. No parallel fan-out — delegate serially, check the result, then decide whether another is warranted. Any file-writing agent gets its own worktree.

# agent workflow (all repos)
* Non-trivial task → work the loop in `~/.claude/AGENT_WORKFLOW.md` (research → plan → implement → run → review → wrap-up), or invoke the `workflow` skill. A repo's own AGENTS.md/CLAUDE.md wins where they conflict.
* Never claim something works until it has been run and seen to work. Report failures with their output; name any skipped step.
* Optimize the dev loop before the code: one command to build, one to run every gate reusing that build, a filter to run one case, parallel execution, and a visible number that says whether the project got better.
* Parallel agents that write files, or any long/risky change, get their own git worktree. Merge to main and push as soon as gates are green — small green commits, not one big branch.

# comments
Add comments where the WHY is non-obvious: hidden constraints, subtle invariants, workarounds, or behavior that would surprise a reader. File-level one-liners describing purpose are welcome. Don't explain what the code does — well-named identifiers handle that.

## plan mode
* Make the plan extremely concise. Sacrifice grammar for the sake of concision
* At the end of each plan, give me a list of unresolved questions to answer, if any

# Tokens
I'm in a token-constrained environment. Use tokens sparingly, but only if you can acheive the same high quality outcome. Do not sacrifice quality. Just be efficient with your tokens. 

# Who I am
I'm a software engineer with 2 decades experience. Worked in GNC and eVTOL on safety critical software. Worked on clang, lldb. cs01 on github. Created pipx, gdbgui. Not afraid of any software challenges, I welcome them. I love creating things, being creative, being bold. Currently working at Meta for last 8 years. Previously at Boeing and Zee.Aero/KittyHawk/Wisk.

# banned phrases
Applies everywhere: chat, code comments, commit messages, docs, PR descriptions.

* Never write "load-bearing" (or "load bearing"). Say what the thing actually
  does: "this check is what rejects stale handles", not "this check is
  load-bearing".
* Never use an em-dash (the long dash). Use a comma, a colon, parentheses, or
  split the sentence. Applies to my own writing; do not rewrite the user's text
  or existing files unless asked.

# maintenance routines
Run these as periodic sweeps on any mature repo, not just when something breaks.
Each one needs a gate that can't be gamed (a differential oracle, a conformance
sweep, a before/after number) or it is just churn. Ordered by what has actually
paid off:

1. **Gate audit**: for every check in CI, confirm it still FAILS when it should.
   A gate whose parser stops matching reports "0 checked" and exits 0 forever.
   This is the highest-value routine and the least-run one.
2. **Crash fuzzer**: random and mutated input at anything with its own memory
   management (GC, arenas, raw index handles). Finds the class of bug no other
   routine finds.
3. **Dup unifier**: merge duplicated implementations. The duplicate is usually
   not merely redundant, it is the WRONG one: it drifted and nobody noticed.
4. **Dead-code removal**: unreachable branches, enum variants nothing
   constructs, generated tables nothing reads.
5. **Abstraction police**: layering violations. Things that are not the layer's
   concern living in its file (host I/O inside a language evaluator).
6. **Abstraction improver**: split files that grew past comprehension, along a
   seam the code already has. Measure the seam first: move the cluster whose
   transitive closure needs the FEWEST new exports.
7. **Useless-test pruner**: tests that cannot fail.
8. **Flaky-test fixer**: root-cause, never retry-loop.

Skip on a young repo with no users: feature-flag inlining, dead-feature
shipping, anything shaped like backwards compatibility.
