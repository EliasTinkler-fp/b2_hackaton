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

Vad agenten faktiskt gor:

- laser in ny kalla eller nytt schema
- inventerar tabeller, kolumner och mojliga nycklar
- dokumenterar vilken grain varje kalltabell verkar ha
- foreslar hur kallan passar in i befintliga `sources`, `staging` och `marts`

Input:

- namn pa ny datakalla
- lista over tabeller eller schema
- malbild, till exempel "ska in i Customer 360"

Output:

- uppdaterad eller ny `sources.yml`
- forslag pa staging-modeller
- lista over antaganden, risker och oklara relationer

### Model Author Agent

Ansvar:

- bygga staging, intermediate och marts
- folja lagerregler och naming conventions
- deklarera grain och nycklar tydligt

Prompt:

- `prompts/model-author.md`

Vad agenten faktiskt gor:

- skapar eller uppdaterar dbt-SQL-modeller
- placerar logik i ratt lager
- bygger slutliga facts och dimensions utifran det underlag som finns
- satter grain och nycklar tydligt i modellen

Input:

- source-definitioner
- antaganden fran onboarding
- maltabeller som ska byggas, till exempel `fct_orders`

Output:

- nya eller uppdaterade modeller i `models/staging`, `models/intermediate`, `models/marts`
- kort sammanfattning av grain, joins och beroenden

### Test Agent

Ansvar:

- lagga till dbt-tests
- kontrollera PK/FK, nullrisker och domanvarden

Prompt:

- `prompts/test-agent.md`

Vad agenten faktiskt gor:

- granskar om modellen har tillrackliga dbt-tests
- lagger till PK-, FK- och kvalitetskontroller
- pekar ut modeller som fortfarande ar for svagt testade

Input:

- nya eller andrade modeller
- YAML-filer for models

Output:

- uppdaterade YAML-filer med tests
- lista over kvarvarande testrisker

### Documentation Agent

Ansvar:

- skriva model YAML descriptions
- dokumentera grain, syfte, antaganden och beroenden

Prompt:

- `prompts/docs-writer.md`

Vad agenten faktiskt gor:

- skriver eller forbattrar modellbeskrivningar
- dokumenterar grain, syfte, nycklar och viktiga matt
- uppdaterar kompletterande markdown-dokumentation vid behov

Input:

- andrade modeller
- tester och grain-beskrivningar fran tidigare steg

Output:

- uppdaterade YAML descriptions
- uppdaterade markdown-dokument
- lista over kvarvarande antaganden

### Reviewer Agent

Ansvar:

- identifiera risker i SQL, grain, joins, schema-placering, tester och docs
- leverera reviewfynd fore PR eller merge

Prompt:

- `prompts/reviewer.md`

Vad agenten faktiskt gor:

- laser diffen som om den vore en riktig PR
- letar efter risker i grain, joins, schema-placering och testluckor
- bedomer om modellen ar rimlig for Power BI/app-konsumtion

Input:

- diff eller andrade filer
- dokumentation och tests fran tidigare steg

Output:

- reviewfynd sorterade efter allvarlighetsgrad
- oppna fragor
- rekommendation om klart for PR eller inte

## Rekommenderat arbetsflode

1. Skapa branch for forandringen.
2. Kor `Source Onboarding Agent` om en ny kalla ska in.
3. Kor `Model Author Agent` for modelleringen.
4. Kor `Test Agent` for att komplettera eller verifiera testning.
5. Kor `Documentation Agent` for YAML och projektanteckningar.
6. Kor `Reviewer Agent` innan commit eller PR.
7. Lat CI verifiera samma regler i GitHub Actions.

## Smidig anvandning i vardagen

Det enklaste ar att se agenterna som en stafett, dar varje steg lamnar over ett tydligt resultat till nasta steg.

### Kort kedja for sma andringar

Anvand denna nar ni bara justerar en befintlig modell eller lagger till ett mindre falt:

1. `Model Author Agent`
2. `Test Agent`
3. `Documentation Agent`
4. `Reviewer Agent`

Detta ar den vanligaste och snabbaste kedjan.

### Full kedja for ny datakalla

Anvand denna nar ni onboardar ny data till Customer 360:

1. `Source Onboarding Agent`
2. `Model Author Agent`
3. `Test Agent`
4. `Documentation Agent`
5. `Reviewer Agent`
6. CI i GitHub

Detta ar den rekommenderade standardkedjan for allt nytt arbete.

## Hur kedjan ska fungera mellan agenterna

Varje agent ska ge nasta agent ett tydligt underlag.

### Steg 1 till 2

`Source Onboarding Agent` lamnar vidare:

- grain per kalltabell
- kandidatnycklar
- forslag pa relationer
- forslag pa staging-modeller

`Model Author Agent` anvander detta for att bygga modeller utan att behova gissa om kallsidan.

### Steg 2 till 3

`Model Author Agent` lamnar vidare:

- vilka modeller som skapats eller andrats
- vilken grain de har
- vilka nycklar och joins som anvants

`Test Agent` anvander detta for att veta vilka tester som ska sattas.

### Steg 3 till 4

`Test Agent` lamnar vidare:

- vilka tester som lades till
- vilka testluckor som finns kvar

`Documentation Agent` anvander detta for att beskriva modellen pa ett satt som matchar verklig kvalitet och verkliga begransningar.

### Steg 4 till 5

`Documentation Agent` lamnar vidare:

- uppdaterade YAML-beskrivningar
- kvarvarande antaganden

`Reviewer Agent` gor slutgranskningen med hela bilden:

- modell
- tests
- docs

## Praktiskt arbetssatt for teamet

For att gora detta smidigt i praktiken kan ni kora sa har:

1. En person eller agent gor onboarding/model-author.
2. Samma person eller en annan kor test och docs.
3. Reviewer-agenten kor sist fore PR.
4. PR skapas med checklistan i `.github/pull_request_template.md`.
5. GitHub Actions kor dbt-validering.

Det gor att ni slipper "ad hoc"-arbete och far ett konsekvent flode aven nar olika personer i teamet driver olika datakallor.

## Minsta fungerande standard for varje ny datakalla

Nar nagon sager "lagg till en ny datakalla" bor standardkedjan vara:

1. Kor `source-onboarding.md`
2. Skapa `sources.yml`
3. Bygg staging
4. Bygg intermediate eller mart vid behov
5. Lagga till tests
6. Lagga till docs
7. Kor reviewer-agent
8. Oppna PR
9. Lat CI verifiera

Om ni haller er till den kedjan far ni ett arbetsflode som ar enkelt att repetera och latt att forklara for resten av teamet.

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
