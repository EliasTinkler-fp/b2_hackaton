# Agent Workflow for dbt + Databricks

Detta dokument beskriver hur teamet ska anvanda AI-agenter i ett delat arbetsflode for dbt, Databricks och Customer 360-projektet.

## Mal

Skapa ett reproducerbart flode dar agenter hjalper till med:

- onboarding av nya datakallor
- modellering i dbt
- tester
- dokumentation
- code review
- PR-validering innan merge

## Grundprincip

Agenterna ar **roller** i arbetsflodet, inte en separat driftmiljo.

Det betyder att:

- varje utvecklare kor sin egen agent lokalt
- regler, prompts och CI ligger i repot
- samma flode kan anvandas av hela teamet

## Roller

### Source Onboarding Agent

Ansvar:

- analysera ny datakalla
- skapa eller uppdatera `sources.yml`
- foresla staging-modeller
- beskriva grain, nycklar och antaganden

Prompt:

- `prompts/source-onboarding.md`

### Model Author Agent

Ansvar:

- bygga staging, intermediate och marts
- folja lagerregler och naming conventions
- deklarera grain och nycklar tydligt

Prompt:

- `prompts/model-author.md`

### Test Agent

Ansvar:

- lagga till dbt-tests
- kontrollera PK/FK, nullrisker och domanvarden

Prompt:

- `prompts/test-agent.md`

### Documentation Agent

Ansvar:

- skriva model YAML descriptions
- dokumentera grain, syfte, antaganden och beroenden

Prompt:

- `prompts/docs-writer.md`

### Reviewer Agent

Ansvar:

- identifiera risker i SQL, grain, joins, schema-placering, tester och docs
- leverera reviewfynd fore PR eller merge

Prompt:

- `prompts/reviewer.md`

## Rekommenderat arbetsflode

1. Skapa branch for forandringen.
2. Kor `Source Onboarding Agent` om en ny kalla ska in.
3. Kor `Model Author Agent` for modelleringen.
4. Kor `Test Agent` for att komplettera eller verifiera testning.
5. Kor `Documentation Agent` for YAML och projektanteckningar.
6. Kor `Reviewer Agent` innan commit eller PR.
7. Lat CI verifiera samma regler i GitHub Actions.

## Vad CI ska verifiera

For dbt-paverkande andringar ska CI kora:

- `dbt deps`
- `dbt parse`
- `dbt compile`
- `dbt build`
- `dbt test`

Vid behov kan ni senare lagga till:

- `dbt docs generate`
- source freshness
- state-based selection

## Delat ansvar i teamet

Alla i teamet bor anvanda samma:

- promptfiler
- PR-template
- CI-workflow
- checklistor for ny datakalla

Detta gor att agentflodet blir teamets arbetssatt, inte bara en persons lokala setup.
