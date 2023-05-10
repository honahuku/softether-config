# config
## build
```bash
docker image build --progress=plain -t softether -f Dockerfile .
docker run --cap-add=NET_ADMIN -p 443:443 softether:latest
```
