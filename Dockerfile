FROM python:3.7
RUN apt-get update \
    && apt-get install -qqy --no-install-recommends \
        apt-utils \
        ffmpeg \
        sox \
        libcairo2-dev \
        texlive \
        texlive-fonts-extra \
        texlive-latex-extra \
        texlive-latex-recommended \
        texlive-science \
        tipa \
    && rm -rf /var/lib/apt/lists/*
COPY \
  LICENSE \
  README.md \
  entrypoint.sh \
  /root/
ENTRYPOINT ["/root/entrypoint.sh"]