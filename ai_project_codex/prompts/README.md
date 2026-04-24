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

## Tva praktiska kedjor

### Kort kedja for vanlig modellandring

Anvand denna nar ni andrar en befintlig modell eller lagger till ett mindre falt:

1. `model-author.md`
2. `test-agent.md`
3. `docs-writer.md`
4. `reviewer.md`

### Full kedja for ny datakalla

Anvand denna nar en ny kalla ska in i Customer 360-flodet:

1. `source-onboarding.md`
2. `model-author.md`
3. `test-agent.md`
4. `docs-writer.md`
5. `reviewer.md`

## Vad varje steg ska lamna vidare

- `source-onboarding`:
  - grain
  - kandidatnycklar
  - forslag pa staging
- `model-author`:
  - andrade filer
  - grain per modell
  - joins och nycklar
- `test-agent`:
  - tillagda tester
  - kvarvarande testluckor
- `docs-writer`:
  - uppdaterad YAML och docs
  - antaganden
- `reviewer`:
  - fynd efter allvarlighetsgrad
  - klar for PR eller inte
