# devc-base

Base container image for development environments. Built on latest Fedora with
Homebrew, a non-root `dev` user, and a composable entrypoint system.

## What's included

- Fedora 44
- Common system tools: `curl`, `git`, `gcc`, `make`, `jq`
- Homebrew at `/home/linuxbrew/.linuxbrew`
- Non-root user `dev` (UID 1000) with passwordless sudo
- Composable entrypoint: scripts dropped into `/entrypoint.d` are sourced in
  lexicographic order at startup

## Build

```bash
just build
```

## Reuse

Extend this image by referencing it in your Containerfile:

```dockerfile
FROM ghcr.io/jkhaak/devc-base:latest
```

Drop additional entrypoint scripts into `/entrypoint.d` to extend the startup
behaviour:

```dockerfile
COPY --chown=dev:dev --chmod=755 my-setup.sh /entrypoint.d/20-my-setup.sh
```

Scripts are sourced in lexicographic order, so prefix with a number to control
execution order.

## Container registry

Images are published to the GitHub Container Registry and can be browsed at: https://github.com/jkhaak/devc-base/pkgs/container/devc-base

Built daily for `amd64` and `arm64` architectures.

Available tags:
- `latest` — most recent build
- `YYYmmDD.patch` — date versioned build, e.g. `20260826.0`
- `sha-<commit>` — build tied to a specific commit

## LICENCE

Copyright Jani Haakana, 2026, licenced under the EUPL.
