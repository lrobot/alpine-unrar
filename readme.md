
## alpine use unrar ##

##run unrar with no arg to get help 
docker run --rm -it -v `pwd`:/wkdir `docker build -q .` unrar

#run unrar to extract 
docker run --rm -it -v `pwd`:/wkdir `docker build -q .` unrar x fakerarfile.rar


#in dockerfile, you can copy unrar to your alpine file system to use
COPY --from=lrobot/alpine-rar /bin/unrar /bin/unrar




