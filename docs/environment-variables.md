# Environment variables

The image follows the same environment-variable pattern as the official graphify image: everything is read at runtime,
nothing sensitive is baked in.

## Set by the image

| Variable                | Default   | Purpose                                                 |
|-------------------------|-----------|---------------------------------------------------------|
| `GRAPHIFY_OUT`          | `/data`   | Output directory for `graph.json` (the mounted volume)  |
| `GRAPHIFY_API_KEY`      | _(empty)_ | Require this key on the HTTP transport; empty = no auth |
| `GRAPHIFY_MAX_CONTEXTS` | _(empty)_ | Max projects one MCP instance serves                    |
| `PYTHONUNBUFFERED`      | `1`       | Unbuffered logs to stdout/stderr                        |

## MCP server tuning

| Variable                                                                          | Purpose                            |
|-----------------------------------------------------------------------------------|------------------------------------|
| `GRAPHIFY_MAX_GRAPH_BYTES`                                                        | Cap on accepted graph size         |
| `GRAPHIFY_QUERY_LOG` / `GRAPHIFY_QUERY_LOG_ENABLE` / `GRAPHIFY_QUERY_LOG_DISABLE` | Query logging                      |
| `GRAPHIFY_QUERY_LOG_RESPONSES`                                                    | Include responses in the query log |
| `GRAPHIFY_DEBUG`                                                                  | Verbose diagnostics                |

## Build / CLI behavior

| Variable                                                        | Purpose                         |
|-----------------------------------------------------------------|---------------------------------|
| `GRAPHIFY_FORCE`                                                | Force a full rebuild            |
| `GRAPHIFY_CHANGED`                                              | Limit a build to changed files  |
| `GRAPHIFY_NO_INCREMENTAL_CACHE`                                 | Disable the incremental cache   |
| `GRAPHIFY_NO_BACKUP`                                            | Skip graph backups              |
| `GRAPHIFY_MAX_WORKERS`                                          | Parallel extraction workers     |
| `GRAPHIFY_REPO_ROOT`                                            | Override the detected repo root |
| `GRAPHIFY_REBUILD_TIMEOUT` / `GRAPHIFY_REBUILD_MEMORY_LIMIT_MB` | Rebuild guardrails              |

## LLM backends

graphify auto-detects the backend from whichever keys are present:

| Variable                                                                                                                        | Backend                                |
|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|
| `OPENAI_API_KEY`, `OPENAI_BASE_URL`, `OPENAI_MODEL`                                                                             | OpenAI and OpenAI-compatible endpoints |
| `ANTHROPIC_API_KEY`, `ANTHROPIC_BASE_URL`, `ANTHROPIC_MODEL`                                                                    | Anthropic                              |
| `GEMINI_API_KEY` / `GOOGLE_API_KEY`, `GEMINI_BASE_URL`                                                                          | Google Gemini                          |
| `DEEPSEEK_API_KEY`, `DEEPSEEK_BASE_URL`                                                                                         | DeepSeek                               |
| `MOONSHOT_API_KEY`, `KIMI_BASE_URL`                                                                                             | Moonshot / Kimi                        |
| `AZURE_OPENAI_ENDPOINT`, `AZURE_OPENAI_DEPLOYMENT`, `AZURE_OPENAI_API_VERSION`, `GRAPHIFY_AZURE_MODEL`                          | Azure OpenAI                           |
| `OLLAMA_HOST` / `OLLAMA_BASE_URL`, `OLLAMA_MODEL`, `GRAPHIFY_OLLAMA_*`                                                          | Local Ollama                           |
| `AWS_ACCESS_KEY_ID`, `AWS_PROFILE`, `AWS_REGION` / `AWS_DEFAULT_REGION`                                                         | AWS Bedrock                            |
| `GRAPHIFY_LLM_TEMPERATURE`, `GRAPHIFY_LLM_TOKENS`, `GRAPHIFY_MAX_OUTPUT_TOKENS`, `GRAPHIFY_MAX_RETRIES`, `GRAPHIFY_API_TIMEOUT` | Shared LLM tuning                      |
| `GRAPHIFY_ALLOW_LOCAL_PROVIDERS`                                                                                                | Permit localhost providers             |

## Graph backends & extractors

| Variable                                                         | Purpose                 |
|------------------------------------------------------------------|-------------------------|
| `NEO4J_URI` / `NEO4J_USER` / `NEO4J_PASSWORD`                    | Neo4j export            |
| `FALKORDB_PASSWORD`                                              | FalkorDB export         |
| `GRAPHIFY_WHISPER_MODEL`, `GRAPHIFY_WHISPER_PROMPT`              | Audio transcription     |
| `GRAPHIFY_GOOGLE_WORKSPACE`, `GRAPHIFY_GOOGLE_WORKSPACE_TIMEOUT` | Google Workspace ingest |

!!! tip In compose, reference host env vars without values to pass them through only when set:
`OPENAI_API_KEY: ${OPENAI_API_KEY:-}`.
