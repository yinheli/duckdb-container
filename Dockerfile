FROM debian:bookworm-slim
ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai

RUN sed -i 's|deb.debian.org|mirrors.ustc.edu.cn|g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    vim wget curl unzip \
    && rm -rf /var/lib/apt/lists/*

# Copy mc binary from official MinIO mc image
COPY --from=minio/mc:latest /usr/bin/mc /usr/sbin/mc

# Install DuckDB by downloading binary (no official Docker image available)
RUN if [ "$TARGETARCH" = "arm64" ]; then \
      curl -L -o duckdb_cli-linux-aarch64.zip \
        https://github.com/duckdb/duckdb/releases/download/v1.3.2/duckdb_cli-linux-aarch64.zip; \
    else \
      curl -L -o duckdb_cli-linux-amd64.zip \
        https://github.com/duckdb/duckdb/releases/download/v1.3.2/duckdb_cli-linux-amd64.zip; \
    fi && \
    unzip duckdb_cli-linux-*.zip && \
    mv duckdb /usr/sbin/duckdb && \
    rm duckdb_cli-linux-*.zip

# Install DuckDB extensions
RUN \
  duckdb -c 'install arrow;' && \
  duckdb -c 'install autocomplete;' && \
  duckdb -c 'install excel;' && \
  duckdb -c 'install fts;' && \
  duckdb -c 'install httpfs;' && \
  duckdb -c 'install iceberg;' && \
  duckdb -c 'install inet;' && \
  duckdb -c 'install mysql;' && \
  duckdb -c 'install postgres;' && \
  duckdb -c 'install spatial;' && \
  duckdb -c 'install sqlite;' && \
  echo 'done installing extensions'

CMD ["duckdb"]
