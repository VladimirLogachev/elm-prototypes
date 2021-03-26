# Elm in docker

## This example demonstrates a minimal realistic Elm setup

- **dev** and **prod** configurations for Docker _(both with SPA routing and serving static assets)_
- Heavily optimized production Elm build _(with CSS and JS inlined in HTML for super-quick load)_
- `elm-format` validation ans `elm-test` unit-tests on CI _(via GitHub actions)_

### Extra
- Works on Apple ARM64
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