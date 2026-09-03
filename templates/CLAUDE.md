# <Project Name>

<!-- Starter CLAUDE.md. Delete every line you do not need — this file loads into
     context on every session, and length costs adherence. Target under ~200 lines.
     Test: "would removing this line cause Claude to make a mistake?" -->

## Commands

<!-- The most important section. Without it Claude guesses how to run your suite;
     with it, Claude verifies its own work and iterates until it passes. -->

- Install: `npm ci`
- Build: `npm run build`
- Test: `npm test`
- Test one file: `npm test -- path/to/file.test.ts`
- Lint: `npm run lint`

## Architecture

<!-- Only what Claude cannot work out by reading the code. Delete the obvious. -->

- API handlers: `src/api/handlers/`
- Shared types: `src/types/`
- Do not read: `node_modules/`, `dist/`, `coverage/`

## Conventions

<!-- Rules that differ from the language or framework default. Those are the ones
     worth spending context on. -->

- All API responses go through `ResponseWrapper` in `src/types/api.ts`
- Check `src/utils/` before adding a utility — do not create a new file
- Tests live beside the code as `*.test.ts`

## Gotchas

<!-- Things that have already bitten someone. The highest-value lines in the file. -->

- `npm test` needs a local Redis; start it with `docker compose up -d redis`
