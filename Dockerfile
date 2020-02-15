FROM haskell:8.6.5 as pandoc-builder

MAINTAINER Bogi Napoleon Wennerstrøm <bogi.wennerstrom@gmail.com>

# install latex packages
RUN apt-get update -y \
  && apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
    texlive-latex-base \
    texlive-xetex latex-xcolor \
    texlive-math-extra \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-bibtex-extra \
    fontconfig \
    lmodern \
    python-dev \
    python-pip

# will ease up the update process
# updating this env variable will trigger the automatic build of the Docker image
ENV PANDOC_VERSION "2.9.1.1"

RUN cabal new-update
RUN cabal new-install cabal-install
RUN cabal user-config update
RUN cabal new-configure
RUN cabal new-install --reorder-goals --max-backjumps=-1 \
                      --constraint=pandoc==${PANDOC_VERSION}\
                      pandoc \
                      pandoc-citeproc \
                      pandoc-citeproc-preamble \
                      pandoc-crossref

# install pandoc figure numberings
#RUN python -m pip install --upgrade setuptools
#RUN pip install pandoc-fignos
#RUN pip install pandoc-eqnos
#RUN pip install pandoc-tablenos

WORKDIR /source

ENTRYPOINT ["/bin/bash"]

CMD ["--help"]