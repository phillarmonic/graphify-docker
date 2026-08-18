# Using the MCP server

The image ships the `graphify-mcp` entrypoint (the same code as
`python -m graphify.serve`), serving a mounted `graph.json` over either **Streamable HTTP** (the default) or **stdio**.

## HTTP transport (default)

```bash
docker run -d --name graphify-mcp \
  -p 8080:8080 \
  -v "$(pwd)/graphify-out:/data" \
  -e GRAPHIFY_API_KEY="$SECRET" \
  phillarmonic/graphify-docker
```

The server listens at `http://localhost:8080/mcp`.

!!! warning "Always set an API key on the network"
Binding `0.0.0.0` without `GRAPHIFY_API_KEY` exposes your graph unauthenticated — the server prints a warning on startup
for exactly this reason. Set `-e GRAPHIFY_API_KEY=...` and require it from clients.

Clients authenticate with either header:

```text
Authorization: Bearer <key>
X-API-Key: <key>
```

### Custom server flags

Anything you pass to `docker run <image> ...` goes straight to
`graphify-mcp`:

```bash
docker run --rm -p 9000:9000 -v "$(pwd)/graphify-out:/data" \
  phillarmonic/graphify-docker \
  /data/graph.json --transport http --host 0.0.0.0 --port 9000 \
  --path /mcp --json-response --stateless
```

| Flag                | Default                                 | Purpose                                   |
|---------------------|-----------------------------------------|-------------------------------------------|
| `--transport`       | `stdio` (image CMD overrides to `http`) | `stdio` or `http`                         |
| `--host` / `--port` | `127.0.0.1` / `8080`                    | Bind address                              |
| `--api-key`         | `$GRAPHIFY_API_KEY`                     | Require auth on HTTP                      |
| `--path`            | `/mcp`                                  | HTTP mount path                           |
| `--json-response`   | off                                     | Plain JSON instead of SSE                 |
| `--stateless`       | off                                     | No per-session state (load-balanced / CI) |
| `--session-timeout` | `3600`                                  | Idle session reap (seconds, `0` disables) |

### docker compose

The repo ships a ready-to-use [`docker-compose.yml`](cli.md#docker-compose):

```bash
GRAPHIFY_API_KEY=change-me docker compose up -d
```

### Pointing MCP clients at it

=== "Claude Code"

    ```bash
    claude mcp add --transport http graphify http://localhost:8080/mcp \
      --header "Authorization: Bearer change-me"
    ```

=== "Claude Desktop / Cursor"

    ```json
    {
      "mcpServers": {
        "graphify": {
          "url": "http://localhost:8080/mcp",
          "headers": {
            "Authorization": "Bearer change-me"
          }
        }
      }
    }
    ```

## stdio transport

For MCP clients that prefer spawning a local process, run the container in stdio mode with `-i`:

```json
{
  "mcpServers": {
    "graphify": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-v",
        "/absolute/path/to/graphify-out:/data",
        "phillarmonic/graphify-docker",
        "/data/graph.json",
        "--transport",
        "stdio"
      ]
    }
  }
}
```

!!! note stdio mode needs `-i` (interactive) so the container's stdin stays attached; drop `-p` since nothing is served
over the network.

## Multiple projects

One server can host several graphs. Set `GRAPHIFY_MAX_CONTEXTS` to raise the project limit and mount each project's
`graphify-out` under its own path, then pass the matching `--graph` per context.
