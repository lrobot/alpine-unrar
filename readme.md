
## alpine use unrar ##

### run unrar with no arg to get help ###

```
git clone https://github.com/lrobot/alpine-unrar.git
cd alpine-unrar
docker run --rm -it -v `pwd`:/wkdir `docker build -q .` unrar
```

### run unrar to extract ###

```
git clone https://github.com/lrobot/alpine-unrar.git
cd alpine-unrar
docker run --rm -it -v `pwd`:/wkdir `docker build -q .` unrar x fakerarfile.rar
```

### in dockerfile, you can copy unrar to your alpine file system to use ###

```
COPY --from=lrobot/alpine-unrar /bin/unrar /bin/unrar
```



