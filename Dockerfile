FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai
RUN sed -i 's|deb.debian.org|mirrors.ustc.edu.cn|g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    vim wget curl unzip \
    && rm -rf /var/lib/apt/lists/*
RUN curl -L -o /usr/sbin/mc https://dl.min.io/client/mc/release/linux-amd64/mc && chmod +x /usr/sbin/mc
RUN \
  curl -L -o duckdb_cli-linux-amd64.zip \
    https://github.com/duckdb/duckdb/releases/download/v0.10.2/duckdb_cli-linux-amd64.zip && \
  unzip duckdb_cli-linux-amd64.zip && \
  mv duckdb /usr/sbin/duckdb && \
  rm duckdb_cli-linux-amd64.zip
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
