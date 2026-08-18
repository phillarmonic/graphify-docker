# Development & publishing

## Build locally

```bash
docker build -f docker/Dockerfile -t phillarmonic/graphify-docker .
```

Pin a specific graphify release instead of the latest PyPI version:

```bash
docker build -f docker/Dockerfile \
  --build-arg GRAPHIFY_VERSION=1.2.3 \
  -t phillarmonic/graphify-docker .
```

Multi-arch locally (requires buildx + QEMU):

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -f docker/Dockerfile -t phillarmonic/graphify-docker .
```

## How releases work

`.github/workflows/build-push.yml` publishes to Docker Hub as
`phillarmonic/graphify-docker` for `linux/amd64` and `linux/arm64`:

- **Push a tag** (`v1.2.3` or `1.2.3`) → pushes `:latest`, `:1`, and `:1.2.3`
- **Manual dispatch** → optionally pins the `graphifyy` version installed in
  the image; pushes `:edge` and `:latest`

The workflow needs two repository secrets:

| Secret | Value |
|---|---|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PAT` | Docker Hub personal access token |

To cut a release that matches an upstream graphify version, tag this repo with
that version and pass it as the `graphify_version` input (or rebuild by
re-tagging once the release lands on PyPI).

## Documentation

The docs you're reading are built with [Zensical](https://zensical.org) and
deployed to GitHub Pages by `.github/workflows/docs.yml` on every push to the
default branch.

```bash
uvx zensical serve   # live preview
uvx zensical build --clean --strict   # what CI runs
```

## Image layout

| Path | Purpose |
|---|---|
| `/opt/uv-local` | uv tool install of `graphifyy[all]` (`graphify`, `graphify-mcp` on `PATH`) |
| `/data` | `VOLUME` for `graph.json` — mounted at runtime |
| `/usr/local/bin/docker-entrypoint.sh` | Routes args to the CLI or the MCP server |
| user `graphify` (uid 10001) | Non-root runtime user |
