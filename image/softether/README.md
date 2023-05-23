### build & push
```sh
cd image/
docker image build --progress=plain -t ghcr.io/honahuku/softether:"4.38.9760-0.16" -f Dockerfile --build-arg SERVER_PASS=xxx .
# ghcr.ioにログインしていることを確認する
docker push ghcr.io/honahuku/softether:"4.38.9760-0.16"
```
### run
```sh
docker run -it -p 443:443 ghcr.io/honahuku/softether:"4.38.9760-0.16"
docker stop $(docker ps -q)
```

### exec
```bash
kubectl exec -it se-deployment-774fcbfc4d-k45gg -n softether -- /bin/bash
```

### apply
```bash
kubectl apply -k ../../manifest/softether/
```
