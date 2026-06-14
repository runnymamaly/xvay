ARG ALPINE=3.23.3

FROM alpine:${ALPINE}
LABEL org.opencontainers.image.authors="Axl <https://github.com/ADKix>"
RUN apk add -U --no-cache 7zip util-linux-misc libqrencode-tools
WORKDIR "/opt/"
RUN wget -qnc "https://github.com/runnymamaly/core/raw/refs/heads/main/core-linux-64.zip"
RUN unzip core-linux-64.zip
RUN 7z a "xcore.7z" "xcore"
COPY "entrypoint.sh" /
COPY "command.sh" /opt
COPY "configs.sh" /opt
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["sh", "/opt/command.sh"]
ENV PORT=443
ENV NETWORK=ws
ENV SNI=www.google.com
RUN mkdir -p "/opt/data"
EXPOSE 443
EXPOSE 2087
