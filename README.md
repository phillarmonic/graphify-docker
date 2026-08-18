# graphify-docker

A Dockerized [graphify](https://github.com/phillarmonic/graphify) container for
graphify and its MCP server — built on [uv](https://docs.astral.sh/uv/) via
`uv tool install "graphifyy[all]"`, published for `linux/amd64` and
`linux/arm64` in Docker Hub as **`phillarmonic/graphify-docker`**.

```bash
# Serve a graph over MCP (Streamable HTTP) on :8080
docker run -d -p 8080:8080 \
  -v "$(pwd)/graphify-out:/data" \
  -e GRAPHIFY_API_KEY="change-me" \
  phillarmonic/graphify-docker

# Or run the CLI
docker run --rm -v "$(pwd):/work" -w /work \
  phillarmonic/graphify-docker graphify update .
```

Documentation: <https://phillarmonic.github.io/graphify-docker/>

## Releasing

Push a tag (`v1.2.3`) and the
[build-push workflow](.github/workflows/build-push.yml) publishes
`:latest`, `:1`, and `:1.2.3` to Docker Hub. Requires `DOCKER_USERNAME` and
`DOCKER_PAT` repository secrets.
