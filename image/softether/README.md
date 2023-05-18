### build & push
```sh
cd image/
docker image build --progress=plain -t ghcr.io/honahuku/softether:"4.38.9760-0.14" -f Dockerfile --build-arg SERVER_PASS=xxx .
# ghcr.ioにログインしていることを確認する
docker push ghcr.io/honahuku/softether:"4.38.9760-0.14"
```
### run
```sh
docker run -it -p 443:443 ghcr.io/honahuku/softether:"4.38.9760-0.14"
docker stop $(docker ps -q)
```

### exec
```bash
kubectl exec -it se-deployment-5fd6fdf6b5-9j2tq -n softether -- /bin/bash
```

### apply
```bash
kubectl apply -k manifest/softether/
```
