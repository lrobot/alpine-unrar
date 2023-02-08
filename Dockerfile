FROM --platform=${BUILDPLATFORM} alpine:latest as builder
MAINTAINER lrobot <lrobot.qq@gmail.com>
#RUN wget -O - https://raw.githubusercontent.com/lrobot/alpine-unrar/main/setup-apkreps.sh | sh
#RUN wget -O - https://cdgo.oss-cn-chengdu.aliyuncs.com/setup-apkreps.sh | sh
RUN apk add --no-cache gcc g++ make
RUN wget https://www.rarlab.com/rar/unrarsrc-6.2.5.tar.gz
RUN tar xzvf unrarsrc-6.2.5.tar.gz
WORKDIR /unrar
RUN sed -i 's/#LDFLAGS=-static/LDFLAGS=-static/g' makefile
RUN make

FROM alpine:latest
MAINTAINER lrobot <lrobot.qq@gmail.com>
LABEL org.opencontainers.image.source="https://github.com/lrobot/alpine-unrar"
WORKDIR /wkdir
COPY --from=builder /unrar/unrar /bin/unrar
ENTRYPOINT [""]
CMD [""]
