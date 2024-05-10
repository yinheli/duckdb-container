# duckdb container

Duckdb with extensions pre-installed. for personal usage. 

## Usage

### Create a pod on kubernetes cluster

```bash
kubectl create -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: duckdb-cli
spec:
  terminationGracePeriodSeconds: 0
  # nodeSelector:
  #   kubernetes.io/hostname: xxx
  containers:
    - name: duckdb
      # for speed up in China
      # image: docker.mirrors.sjtug.sjtu.edu.cn/yinheli/duckdb:latest
      image: yinheli/duckdb:latest
      imagePullPolicy: Always
      resources:
        limits:
          cpu: 8000m
          memory: 16Gi
          ephemeral-storage: 20Gi
        requests:
          cpu: 1m
          memory: 128Mi
          ephemeral-storage: 10Gi
      env:
        - name: TZ
          value: Asia/Shanghai
      command:
        - sh
        - -c
        - tail -f /dev/null
      workingDir: /root
  restartPolicy: Never
EOF
```

### Run with Docker 

```bash
docker run -it --rm -v $(pwd):/data yinheli/duckdb:latest bash
```

## Resources

- [DuckDB docs](https://duckdb.org/docs/)