### build & push
```sh
cd image/
docker image build --progress=plain -t ghcr.io/honahuku/softether:"4.38.9760-0.23" -f Dockerfile --build-arg SERVER_PASS=xxx .
# ghcr.ioにログインしていることを確認する
docker push ghcr.io/honahuku/softether:"4.38.9760-0.23"
```
### run
```sh
docker run -it -p 443:443 ghcr.io/honahuku/softether:"4.38.9760-0.23"
docker stop $(docker ps -q)
```

### exec
```bash
kubectl exec -it se-deployment-884665986-mh8tf -n softether -- /bin/bash
```

### apply
```bash
kubectl apply -k ../../manifest/softether/
```

### tshark
```bash
tshark -i tap_soft -f "port 67 or port 68"
ps aux | grep kea
nmap -sU -p 67 localhost
```
