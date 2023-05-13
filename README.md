# config
## build
### build & push
```sh
cd image/
docker image build --progress=plain -t ghcr.io/honahuku/softether:"4.38.9760" -f Dockerfile --build-arg SERVER_PASS=xxx .
# ghcr.ioにログインしていることを確認する
docker push ghcr.io/honahuku/softether:"4.38.9760"
```
### run
```sh
docker run -p 443:443 ghcr.io/honahuku/softether:"4.38.9760"
docker stop $(docker ps -q)
```
