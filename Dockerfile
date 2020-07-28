FROM xucheng/texlive-full:latest
RUN pwd && ls
COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
