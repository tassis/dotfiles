---
name: lobehub-marketplace
description: LobeHub marketplace skills, find/install skill, Claude Code skill, Codex skill, Cursor skill, SKILL.md. Use when the user asks to find a skill for a task, install a marketplace skill, evaluate whether a third-party skill can work in OpenCode, or bridge external skills into OpenCode. Prefer analysis first and ask before installing unless the user explicitly wants immediate install.
---

# LobeHub Marketplace Bridge for OpenCode

Use this skill to search, inspect, and selectively install skills from LobeHub Marketplace while staying compatible with OpenCode.

This skill is intentionally conservative:

- prefer search and analysis before installation;
- ask before installing unless the user clearly asked for immediate install;
- treat Claude Code / Codex / Cursor skills as potentially portable, not automatically OpenCode-native;
- read installed `SKILL.md` files before assuming the skill is usable.

## Primary use cases

Use this skill when the user asks things like:

- "find a skill for X"
- "is there a skill for this workflow"
- "install this LobeHub skill"
- "can this Claude Code skill work in OpenCode"
- "help me bridge marketplace skills into OpenCode"

Do not use this skill for normal library docs lookup, general coding help, or routine project work that does not involve marketplace skills.

## Ground rules

1. Use `@lobehub/market-cli` commands, not raw HTTP/API requests.
2. Before installing, clarify intent and target location unless the user already gave clear instructions.
3. After installation, always read the installed `SKILL.md`.
4. For non-OpenCode skills, do a portability assessment before claiming the skill is usable.
5. Prefer the smallest safe action: search first, inspect second, install third.

## OpenCode-specific install strategy

OpenCode can use skills from multiple places:

- native global OpenCode skills: `~/.config/opencode/skills/`
- native project OpenCode skills: `.opencode/skills/`
- external auto-loaded skills: `~/.claude/skills/` and `~/.agents/skills/`

When deciding where to install:

1. If the skill is clearly meant to be an external marketplace skill and the CLI already supports its target ecosystem, prefer a bridge path that OpenCode can auto-load, especially `~/.agents/skills/`.
2. If the skill should become a maintained OpenCode-native skill, prefer `~/.config/opencode/skills/<name>/` or `.opencode/skills/<name>/`.
3. If unsure, ask the user before installing.

Default posture: **analyze first, ask second, install third**.

## Workflow

### Step 1: Clarify what the user wants

Before running install commands, determine:

- what capability the user is looking for;
- whether they want search only, analysis only, or actual installation;
- whether the target should be global or project-local;
- whether the skill is OpenCode-native or from another ecosystem.

If the user is cautious about installing random skills, keep the process in analysis mode until they approve an install.

### Step 2: Search the marketplace

Use task-oriented search terms, not vague keywords.

```bash
npx -y @lobehub/market-cli skills search --q "KEYWORD"
```

Search tips:

- use the user goal, not just the file type;
- if the task is broad, search 2-3 variants;
- prefer a small shortlist over a huge dump.

For each promising result, summarize:

- identifier
- name
- description
- stars / installs if shown
- why it may fit
- risk or uncertainty

### Step 3: Inspect before install

Before installing a skill, check:

1. Is the description actually relevant to the requested task?
2. Is it clearly OpenCode-native, or aimed at Claude Code / Codex / Cursor / another tool?
3. Does the install path implied by the marketplace make sense for OpenCode?
4. Would it be safer to install into an external auto-load path instead of OpenCode-native skills?

If the user gave a direct marketplace identifier, still do a quick compatibility assessment before installing.

### Step 4: Register only when needed

Marketplace usage may require registration.

Use:

```bash
npx -y @lobehub/market-cli register --name "<distinctive-name>" --description "<short description>" --source <supported-source>
```

Rules:

- do not spam registration attempts;
- note that the endpoint is rate-limited;
- if OpenCode is not a supported `--source`, explain that limitation and choose the closest supported path only with user approval.

### Step 5: Install carefully

Install only after the user approves, unless they explicitly asked for immediate installation.

Examples:

```bash
npx -y @lobehub/market-cli skills install <identifier>
npx -y @lobehub/market-cli skills install <identifier> --global
npx -y @lobehub/market-cli skills install <identifier> --dir ~/.config/opencode/skills
```

Decision guide:

- use `--dir ~/.config/opencode/skills` when intentionally converting the result into an OpenCode-managed global skill location;
- use `--global` when you want the marketplace CLI's global external skill path and that path is acceptable for OpenCode bridging;
- use project-local install paths only when the user wants per-project scope.

After install, record the exact install path.

### Step 6: Read installed `SKILL.md`

After installation, read `SKILL.md` from the installed directory and assess:

1. whether the frontmatter looks valid for OpenCode;
2. whether the description would make sense for OpenCode triggering;
3. whether the body assumes a different platform or tool layout;
4. whether the instructions are directly usable, partially portable, or incompatible.

Do not claim success before this step.

### Step 7: Portability assessment for non-OpenCode skills

For Claude Code, Codex, Cursor, or other external skills, classify the result into one of these:

#### A. Directly usable

Use this only when:

- the `SKILL.md` structure is compatible enough;
- the instructions are generic;
- the skill does not depend on platform-specific hooks or assumptions.

#### B. Usable with light adaptation

Examples:

- install path adjustments;
- frontmatter cleanup;
- description rewrite for OpenCode triggering;
- replacing ecosystem-specific wording with OpenCode wording.

#### C. Reference only / rewrite needed

Use this when:

- the skill depends on platform-specific tool behavior;
- the metadata format is incompatible;
- the workflow assumes a different runtime or hidden features.

When reporting portability, summarize:

- what works as-is;
- what would need adaptation;
- whether you recommend installing, rewriting, or just using it as reference.

### Step 8: If needed, create an OpenCode-native rewrite

If the user wants to keep the capability but the external skill is not directly usable:

1. extract the useful workflow from the external skill;
2. rewrite it as an OpenCode skill under the correct folder/name structure;
3. make the description explicitly cover OpenCode trigger cases;
4. validate the resulting skill before finalizing it.

## Output expectations

When helping the user, prefer this reporting shape:

### Search result summary

- what you searched for
- shortlist of relevant skills
- why each one is promising

### Compatibility summary

- install target options
- OpenCode compatibility: direct / light adaptation / rewrite needed
- risks or unknowns

### Recommended next step

One of:

- search more
- inspect a specific skill
- install after confirmation
- rewrite as OpenCode-native skill

## Example decisions

### Example 1: user asks "find a skill for PDF editing"

1. Search marketplace with task-oriented terms.
2. Shortlist a few candidates.
3. Recommend the best one and explain whether to inspect or install.
4. Ask before installing.

### Example 2: user asks "install this Claude Code skill into OpenCode"

1. Inspect the skill metadata and `SKILL.md` first.
2. Explain that installable does not always mean OpenCode-compatible.
3. Assess whether the skill is directly usable, lightly portable, or rewrite-only.
4. Ask whether they want installation, adaptation, or just a rewrite.

### Example 3: user asks "set up LobeHub marketplace for OpenCode"

1. Explain the CLI-based workflow.
2. Register only if needed.
3. Choose an install strategy compatible with OpenCode.
4. Install conservatively.
5. Read the installed `SKILL.md` and verify portability.

## What not to do

- Do not install many skills just because search returned them.
- Do not assume a Claude Code skill is automatically usable in OpenCode.
- Do not skip reading installed `SKILL.md`.
- Do not use raw HTTP/API calls when the CLI is available.
- Do not silently choose a risky install target when the user is cautious.
