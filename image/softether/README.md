### build & push
```sh
cd image/
docker image build --progress=plain -t ghcr.io/honahuku/softether:"4.38.9760.v7" -f Dockerfile --build-arg SERVER_PASS=xxx .
# ghcr.ioにログインしていることを確認する
docker push ghcr.io/honahuku/softether:"4.38.9760.v7"
```
### run
```sh
docker run -it -p 443:443 ghcr.io/honahuku/softether:"4.38.9760.v7"
docker stop $(docker ps -q)
```
