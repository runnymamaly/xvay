ARG ALPINE=3.23.3

FROM alpine:${ALPINE}
LABEL org.opencontainers.image.authors="Axl <https://github.com/ADKix>"
RUN apk add -U --no-cache 7zip util-linux-misc libqrencode-tools
WORKDIR "/opt/"

RUN wget -qnc "https://github.com/runnymamaly/core/blob/3fd1a48125cf2e1effb6c9cdb41f66fa400f54db/core-linux-64.zip" -O- | \
      unzip -p - "xcore" | \
        7z -si a "xcore.7z"

COPY "entrypoint.sh" /
COPY "command.sh" /opt
COPY "configs.sh" /opt
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["sh", "/opt/command.sh"]
ENV PORT=443
ENV NETWORK=tcp
ENV SNI=www.google.com
RUN mkdir -p "/opt/data"
EXPOSE 443
