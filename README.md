# Finity People AI Hackathon

Welcome to the AI Development Hackathon! This repo contains everything you need to get set up and start building.

---

## Getting started

There are two ways to get set up — pick whichever feels more comfortable:

### Option A: Let the AI do the setup for you

This is the fastest path. Just install **one** AI coding tool first, then let it handle the rest:

1. Install **Claude Code** or **Codex CLI** (pick one — see the quick install below).
2. Open a terminal in this repo folder.
3. Give it this prompt:

**Claude Code:**
```
claude
```
Then type:
```
Read the setup guides in this repo (setup-python.md, setup-codex.md,
databricks-access-instructions.md) and help me install and configure
everything step by step. Check what I already have installed and skip
what's not needed.
```

**Codex CLI:**
```
codex
```
Then type:
```
Read the setup guides in this repo (setup-python.md, setup-claude.md,
databricks-access-instructions.md) and help me install and configure
everything step by step. Check what I already have installed and skip
what's not needed.
```

The AI will read the guides, check what's already on your machine, and walk you through the rest interactively.

**Quick install — Claude Code:**
- Mac / Linux: `curl -fsSL https://claude.ai/install.sh | bash`
- Windows PowerShell: `irm https://claude.ai/install.ps1 | iex`

**Quick install — Codex CLI:**
- `npm install -g @openai/codex` (requires Node.js 18+)

---

### Option B: Follow the guides manually

Follow the setup guides below in order. Each guide is written step-by-step for all experience levels.

#### 1. Set up your AI coding tools

Pick one or both — these are the AI assistants you'll use to write code during the hackathon:

| Guide | What it covers |
|---|---|
| [Setting up Claude](setup-claude.md) | Claude Desktop app + Claude Code CLI (Anthropic) |
| [Setting up Codex](setup-codex.md) | Codex web app + Codex CLI (OpenAI) |

#### 2. Set up Python

If your project needs Python (most will):

| Guide | What it covers |
|---|---|
| [Setting up Python with uv](setup-python.md) | Installing Python and managing packages using uv |

#### 3. Access the Databricks workspace

Our shared data platform for the hackathon:

| Guide | What it covers |
|---|---|
| [Databricks access instructions](databricks-access-instructions.md) | Browser access, CLI setup, and workspace permissions |

**Workspace URL:** https://adb-7405616827368959.19.azuredatabricks.net/

---

## What you'll need

At minimum:

- A laptop (Mac or Windows)
- A browser (Chrome, Edge, Safari, or Firefox)
- Your corporate credentials (for Databricks access)
- An Anthropic account and/or OpenAI/ChatGPT account (for the AI tools)

---

## Quick links

| Resource | Link |
|---|---|
| Databricks workspace | https://adb-7405616827368959.19.azuredatabricks.net/ |
| Claude Desktop download | https://claude.com/download |
| Claude Code docs | https://code.claude.com/docs/en/setup |
| Codex web app | https://chatgpt.com/codex |
| Codex CLI on GitHub | https://github.com/openai/codex |
| uv (Python toolchain) | https://docs.astral.sh/uv/ |

---

## Repo structure

```
├── README.md                          ← You are here
├── setup-claude.md                    ← Claude Desktop + Claude Code setup
├── setup-codex.md                     ← OpenAI Codex web app + CLI setup
├── setup-python.md                    ← Python installation with uv
└── databricks-access-instructions.md  ← Databricks workspace access
```

---

## Questions or problems?

Ping the admin in Slack/Teams with:

- Your name / email
- What you tried
- The exact error message (a screenshot helps)
