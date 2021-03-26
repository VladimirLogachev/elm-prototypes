# Elm in docker

## This example demonstrates a minimal realistic Elm setup

- **dev** and **prod** configurations for Docker _(both with SPA routing and serving static assets)_
- Heavily optimized production Elm build _(with CSS and JS inlined in HTML for super-quick load)_
- `elm-format` validation ans `elm-test` unit-tests on CI _(via GitHub actions)_

### Extra
- Works on Apple arm64 (except for integration tests in docker)
- VSCode recommended extensions setup

## Requirements

- docker
- docker-compose

## Usage

- Build and run uptimized for production _(no source code in container, only bundled html, assets and nginx)_.

```sh
docker-compose -f dc.prod.yml up -V --build
```

- Build and run in dev mode _(watching files)_

```sh
docker-compose -f dc.dev.yml up -V --build
```

- Run tests during development (requires node, elm and elm-test)

```sh
cd webapp
elm-test "src/**/*Test.elm" --watch
```

### Extra notes

- Run in dev mode (watching files) without docker (requires node, elm and elm-live)

```sh
cd webapp
elm-live "src/Main.elm" \
  --dir="./" \
  --open \
  --host=0.0.0.0 \
  --port=8080 \
  --pushstate \
  --start-page=index.src.html \
  -- \
  --output="./assets/inline/bundle.js"
```

- Why 2 compose files?
  > The idea is that with backend in docker, several docker-compose configurations are combined when necessary from several files via -f flags, or started separately but configured to join a single network, or even composed and exported with Dhall.

## Run integration tests

Integration tests are powered by [Cypress](https://cypress.io/), recorded on video which for this project (elm-prototypes) made public intentionally and are available at [Cypress Dashboard](https://dashboard.cypress.io/projects/411394/runs).

### Run integration tests in headless browser (as on CI)

- Run `bash run-integration-tests.sh` (the results will be recorded to the Cypress Dashboard only if `CYPRESS_RECORD_KEY` env variable is set)

### Run integration tests in headed browser (dev mode, watching changes in tests)

- Run webapp so that it is accessible at `http://localhost:8080`
- Run test with headed browser, watching for changes in test suites

```sh
cd integration-tests
npm i
CYPRESS_BASE_URL=http://localhost:8080 npm test
```