FROM alpine:3.10
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "-l", "/entrypoint.sh"]
