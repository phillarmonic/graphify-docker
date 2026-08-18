# graphify-docker

A Docker image for [graphify](https://github.com/phillarmonic/graphify) and its
MCP server, built on [uv](https://docs.astral.sh/uv/) and published to Docker
Hub as **`phillarmonic/graphify-docker`** for `linux/amd64` and `linux/arm64`.

Unlike the official image (which installs from source with `pip`), this image
installs the published package with every extra enabled:

```bash
uv tool install "graphifyy[all]"
```

That includes the MCP server with the Streamable HTTP transport, all LLM
backends (OpenAI, Anthropic, Gemini, DeepSeek, Moonshot, Azure, Ollama,
Bedrock), document and media extractors (PDF, DOCX, XLSX, audio, YouTube), and
the Neo4j / FalkorDB exporters.

## Quickstart

```bash
# Build a graph for your project first (or mount an existing one)
docker run --rm -v "$(pwd):/work" -w /work \
  phillarmonic/graphify-docker graphify update .

# Serve the graph as an MCP server over HTTP on :8080
docker run -d --name graphify-mcp \
  -p 8080:8080 \
  -v "$(pwd)/graphify-out:/data" \
  -e GRAPHIFY_API_KEY="change-me" \
  phillarmonic/graphify-docker
```

The default command mirrors the official image:

```text
/data/graph.json --transport http --host 0.0.0.0 --port 8080
```

so with no arguments the container serves `/data/graph.json` over Streamable
HTTP at `http://localhost:8080/mcp`.

## How it's laid out

| Piece | Location |
|---|---|
| Dockerfile | `docker/Dockerfile` |
| Entrypoint | `docker/docker-entrypoint.sh` |
| Compose example | `docker-compose.yml` |
| Publish workflow | `.github/workflows/build-push.yml` |
| Docs workflow | `.github/workflows/docs.yml` |

The image runs as a non-root user (`graphify`, uid 10001), mounts graph data at
`/data` (`VOLUME`), and never bakes a `graph.json` or any secrets into the
image — both are supplied at runtime.

## Next steps

- [Using the MCP server](mcp.md) — HTTP and stdio transports, client configs
- [Running the CLI](cli.md) — build graphs inside the container
- [Environment variables](environment-variables.md) — full reference
- [Development & publishing](development.md) — local builds and releases
