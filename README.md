# config
## build
```bash
docker image build --progress=plain -t softether -f Dockerfile --build-arg SERVER_PASS=xxx .
docker run -p 443:443 softether:latest
```
