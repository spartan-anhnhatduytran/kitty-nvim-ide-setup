---
description: Rebase with master, verify migration ordering, then open PR with templated description
---

# spartan-pr

Open PR for current branch. Three guards before push:

1. **Rebase on master** — fast-forward if clean; halt for user if conflict.
2. **Migration ordering** — scan `service/database-migration/sql/` for gaps or duplicate `NNN-` prefixes.
3. **PR body** — fill `.github/pull_request_template.md` from diff summary.

## Steps

### 1. Rebase

Run:
```bash
git fetch origin master
git rebase origin/master
```

If rebase fails with conflict:
- STOP. Do **not** auto-resolve.
- Print conflicting files: `git diff --name-only --diff-filter=U`
- Tell user: "Rebase conflict on N files. Resolve manually, then `git rebase --continue` and re-run /spartan-pr."
- Exit.

If rebase clean: continue.

### 2. Migration order check

Compare current branch to master:
```bash
git diff --name-only origin/master...HEAD -- service/database-migration/sql/
```

For every new `NNN-*.sql`:
- Extract leading 3-digit number.
- Find highest `NNN` on `origin/master` (`ls service/database-migration/sql/ | sort | tail -1`).
- New migrations MUST be strictly `> master_max` AND sequential without gap among themselves.

Fail conditions:
- New migration `NNN` ≤ master_max → out-of-order, will collide on merge.
- Duplicate `NNN` prefix between branches.
- Gap (e.g., master at 042, branch adds 044 but skips 043).

If fail: report `path:NNN reason` per file. Ask user to rename. Exit. Do NOT push.

If pass: continue.

### 3. Build PR body

From `git log origin/master..HEAD --oneline` + `git diff --stat origin/master...HEAD`, derive:

- **Why** — extract from commit subjects (`fix:`/`feat:`/`refactor:` prefix → reason).
- **What** — bullet list of changed areas grouped by top-level dir (`web/`, `service/`, `cms/`, `terraform/`).
- **Solution** — one paragraph on approach, inferred from largest diff hunks.
- **Types of Changes** — auto-tick boxes based on commit prefixes:
  - `feat:` → 🚀 New feature
  - `fix:` → 🕷 Bug fix
  - `refactor:` → 🛠 Refactor
  - `perf:` → 👏 Performance
  - migration touched → 🔒 Security awareness
- **Test Plan** — list affected routes/endpoints + manual repro steps inferred from diff.

### 4. Push + create

```bash
git push -u origin HEAD
gh pr create --title "<title>" --body "$(cat <<'EOF'
<filled template>
EOF
)"
```

Title rule: first commit subject, ≤70 chars.

Return PR URL.

## Constraints

- NEVER add Claude Code citation/attribution to PR body (e.g. `🤖 Generated with [Claude Code](https://claude.com/claude-code)`).
- NEVER force-push.
- NEVER skip hooks.
- NEVER `--no-verify`.
- NEVER edit migration filenames automatically — user renames.
- NEVER drop/squash commits without ask.
- If `gh` not authed: tell user to run `gh auth login` and exit.
