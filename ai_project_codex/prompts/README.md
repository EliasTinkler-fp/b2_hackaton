# Agent Prompts

Detta bibliotek innehaller delade promptfiler for AI-agenter i projektet.

Syftet ar att ge teamet ett gemensamt arbetssatt for:

- dbt-modellering
- testning
- dokumentation
- kodgranskning
- onboarding av nya datakallor

## Hur de anvands

Varje fil kan klistras in i Codex, Claude Code eller annat agentverktyg som system- eller uppgiftsinstruktion.

Prompterna ar avsedda att:

- ge samma krav oavsett vem i teamet som kor agenten
- minska variation i naming, grain, tests och docs
- gora det lattare att onboarda nya kallor med samma flode

## Filer

- `model-author.md`
- `test-agent.md`
- `docs-writer.md`
- `reviewer.md`
- `source-onboarding.md`

## Rekommenderat flode

1. Kor `source-onboarding.md` nar en ny datakalla ska in.
2. Kor `model-author.md` for att bygga sources, staging, intermediate och marts.
3. Kor `test-agent.md` for att lagga till eller komplettera dbt-tests.
4. Kor `docs-writer.md` for YAML-docs och projektanteckningar.
5. Kor `reviewer.md` innan PR eller merge.
