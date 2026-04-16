# Finity People AI Hackathon

Welcome to the AI Development Hackathon! This repo contains everything you need to get set up and start building.

---

## Getting started

There are two ways to get set up — pick whichever feels more comfortable:

### Before you start — you need a paid subscription

The AI coding tools require a paid plan. **Sign up and log in first**, then come back here.

| Tool | Sign up | Required plan |
|---|---|---|
| **Claude Code** | [claude.ai](https://claude.ai) | Pro ($20/mo), Max ($100–200/mo), Teams, or Enterprise. The free plan does **not** include Claude Code. |
| **Codex CLI** | [chatgpt.com](https://chatgpt.com) | Plus, Pro, Business, Edu, or Enterprise. |

You only need one — pick whichever you prefer. The first time you run the tool, it will open a browser window for you to sign in. No API keys or tokens to copy around.

---

### Option A: One-liner — let the AI set up everything for you

The fastest path. Copy-paste **one command** into your terminal. It installs the AI tool, clones this repo, and hands off to the AI to read the setup guides and do the rest.

#### Mac / Linux

**Using Claude Code:**

```bash
curl -fsSL https://claude.ai/install.sh | bash && git clone https://github.com/FinityPeople/fpaihack.git && cd fpaihack && claude -p "Read all the setup guides in this repo (setup-python.md, setup-codex.md, databricks-access-instructions.md). Check what is already installed on this machine and help me install and configure everything that is missing. Walk me through anything that needs my input (like signing in). Skip what is already done."
```

**Using Codex CLI** (requires Node.js 18+ — install from [nodejs.org](https://nodejs.org/) first if needed):

```bash
npm install -g @openai/codex && git clone https://github.com/FinityPeople/fpaihack.git && cd fpaihack && codex "Read all the setup guides in this repo (setup-python.md, setup-claude.md, databricks-access-instructions.md). Check what is already installed on this machine and help me install and configure everything that is missing. Walk me through anything that needs my input (like signing in). Skip what is already done."
```

#### Windows

**Using Claude Code — PowerShell:**

```powershell
irm https://claude.ai/install.ps1 | iex; git clone https://github.com/FinityPeople/fpaihack.git; cd fpaihack; claude -p "Read all the setup guides in this repo (setup-python.md, setup-codex.md, databricks-access-instructions.md). Check what is already installed on this machine and help me install and configure everything that is missing. Walk me through anything that needs my input (like signing in). Skip what is already done."
```

**Using Codex CLI — PowerShell** (requires Node.js 18+ — run `winget install OpenJS.NodeJS.LTS` first if needed):

```powershell
npm install -g @openai/codex; git clone https://github.com/FinityPeople/fpaihack.git; cd fpaihack; codex "Read all the setup guides in this repo (setup-python.md, setup-claude.md, databricks-access-instructions.md). Check what is already installed on this machine and help me install and configure everything that is missing. Walk me through anything that needs my input (like signing in). Skip what is already done."
```

> **Don't have git?** The AI will notice and help you install it. On Windows, download [Git for Windows](https://git-scm.com/downloads/win) first. On Mac, running `git` in the terminal will prompt you to install the Xcode Command Line Tools automatically.

#### What happens when you run this

1. Installs the AI coding tool (Claude Code or Codex CLI)
2. Clones this hackathon repo to your machine
3. The AI reads the setup guides in the repo
4. It checks what's already installed on your machine
5. It installs and configures everything that's missing
6. It asks you for input when needed (e.g. signing in to services)

---

### Option A2: Already have the AI installed? Just run the prompt

If you already have Claude Code or Codex CLI installed, clone the repo and start the AI:

```bash
git clone https://github.com/FinityPeople/fpaihack.git
cd fpaihack
claude   # or: codex
```

Then paste this prompt:

```
Read all the setup guides in this repo (setup-python.md, setup-codex.md,
setup-claude.md, databricks-access-instructions.md). Check what is already
installed on this machine and help me install and configure everything
that is missing. Walk me through anything that needs my input (like signing
in). Skip what is already done.
```

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
- A **paid** Anthropic account ([claude.ai](https://claude.ai) — Pro, Max, Teams, or Enterprise) and/or a **paid** OpenAI account ([chatgpt.com](https://chatgpt.com) — Plus, Pro, Business, Edu, or Enterprise)

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
