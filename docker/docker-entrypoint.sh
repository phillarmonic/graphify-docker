#!/usr/bin/env bash
# Entrypoint for the graphify-docker image.
#
#   docker run image                        -> MCP server over HTTP (the CMD)
#   docker run image /data/graph.json ...   -> MCP server with custom args
#   docker run image graphify build .       -> graphify CLI passthrough
#   docker run image graphify-mcp ...       -> MCP server explicit
#   docker run image sh                     -> shell
set -e

case "$1" in
  graphify|graphify-mcp|sh|bash|python|python3|uv|uvx)
    exec "$@"
    ;;
esac

exec graphify-mcp "$@"
