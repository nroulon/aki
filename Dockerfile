# Dockerfile
# From https://medium.com/@benitomartin/deep-dive-into-uv-dockerfiles-by-astral-image-size-performance-best-practices-5790974b9579

FROM ghcr.io/astral-sh/uv:python3.13-alpine AS builder

# Compile .pyc files
ENV UV_COMPILE_BYTECODE=1

# Disable python download
ENV UV_PYTHON_DOWNLOADS=0


WORKDIR /app
COPY pyproject.toml uv.lock .
RUN uv sync --frozen --no-install-project --no-dev
COPY . .
RUN uv sync --frozen --no-dev

FROM python:3.13-alpine

ENV PYTHONUNBUFFERED=1

# Install aki dependencies
RUN apk add --no-cache docker-cli-compose

COPY --from=builder /app /app
ENV PATH="/app/.venv/bin:$PATH"
ENTRYPOINT ["aki"]
CMD ["--help"]
