# graphify + graphify MCP server, installed with uv (issue #1143 on the
# upstream repo shaped the official image; this one is the uv-based variant).
#
# Build:  docker build -f docker/Dockerfile -t phillarmonic/graphify-docker .
# Run:    docker run -p 8080:8080 -v "$(pwd)/graphify-out:/data" \
#             -e GRAPHIFY_API_KEY="$SECRET" phillarmonic/graphify-docker
#
# The graph.json is mounted at runtime (-v), never baked into the image.
# --- builder: some [all] extras (e.g. tree-sitter-dm) compile from source ---
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

# Pin a graphifyy release at build time (CI passes this; empty = latest).
ARG GRAPHIFY_VERSION=""

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc g++ libc6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install into a path-independent location we can copy into the runtime stage
# (uv tool binaries symlink into the tools dir with absolute paths).
ENV UV_TOOL_DIR=/opt/uv-tools \
    UV_TOOL_BIN_DIR=/opt/uv-tools/bin

# Install graphify with every extra (mcp/http transport, LLM backends, doc
# and media extractors, graph backends) as an isolated uv tool.
RUN if [ -n "$GRAPHIFY_VERSION" ]; then \
      uv tool install "graphifyy[all]==$GRAPHIFY_VERSION"; \
    else \
      uv tool install "graphifyy[all]"; \
    fi

# --- runtime: slim image, no toolchain ---
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

COPY --from=builder /opt/uv-tools /opt/uv-tools
ENV PATH="/opt/uv-tools/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    SHELL=/bin/bash

# Same environment-variable pattern as the official image / graphify itself:
# - GRAPHIFY_API_KEY      require this key on the HTTP transport (empty = off)
# - GRAPHIFY_OUT          where the CLI writes graph.json (mounted volume)
# - GRAPHIFY_MAX_CONTEXTS max projects served by one MCP instance
# GRAPHIFY_API_KEY and the LLM keys (OPENAI_API_KEY, ANTHROPIC_API_KEY,
# GEMINI_API_KEY, ...) are read from the environment at runtime — pass them
# with -e, never bake them into the image.
ENV GRAPHIFY_OUT=/data

COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Run as a non-root user — the server is network-exposed.
RUN useradd --create-home --uid 10001 --shell /bin/bash graphify \
    && chsh -s /bin/bash root \
    && mkdir -p /data && chown graphify:graphify /data
USER graphify

VOLUME ["/data"]
EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
# Official-image default: serve /data/graph.json over Streamable HTTP.
CMD ["/data/graph.json", "--transport", "http", "--host", "0.0.0.0", "--port", "8080"]
