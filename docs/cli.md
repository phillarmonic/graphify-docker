# Running the CLI

The entrypoint passes any recognized command straight through, so the full
graphify CLI is available inside the container:

```bash
docker run --rm -v "$(pwd):/work" -w /work \
  phillarmonic/graphify-docker graphify --help
```

## Build a graph

Mount your project at `/work` and build:

```bash
docker run --rm -v "$(pwd):/work" -w /work \
  phillarmonic/graphify-docker graphify update .
```

Because `GRAPHIFY_OUT=/data` is set in the image, you can also build directly
into the data volume the MCP server serves:

```bash
docker run --rm \
  -v "$(pwd):/work" -w /work \
  -v graphify-data:/data \
  phillarmonic/graphify-docker graphify update .
```

Anything after the image name that isn't `graphify`, `graphify-mcp`, `sh`,
`bash`, `python`, or `uv` is treated as arguments to `graphify-mcp` — so
`docker run <image> --help` shows the MCP server help, and
`docker run <image> graphify query ...` runs the CLI.

## LLM-backed features

Pass provider keys as environment variables; nothing is baked into the image:

```bash
docker run --rm -v "$(pwd):/work" -w /work \
  -e OPENAI_API_KEY \
  -e OPENAI_BASE_URL \
  -e OPENAI_MODEL \
  phillarmonic/graphify-docker graphify update .
```

See [Environment variables](environment-variables.md) for every supported key.

## docker compose

The included `docker-compose.yml` runs the MCP server; override the command to
run one-off CLI jobs against the same volume:

```bash
docker compose run --rm --entrypoint graphify \
  -v "$(pwd):/work" -w /work \
  graphify-mcp build .
```
