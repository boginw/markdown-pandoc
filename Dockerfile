FROM haskell:8.0

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
ENV PANDOC_VERSION "1.19.2.1"

# install pandoc
RUN cabal update 
RUN cabal install pandoc-${PANDOC_VERSION} 
RUN cabal install pandoc-citeproc
RUN cabal install pandoc-crossref
RUN cabal install pandoc-include

# install pandoc figure numberings
#RUN python -m pip install --upgrade setuptools
#RUN pip install pandoc-fignos
#RUN pip install pandoc-eqnos
#RUN pip install pandoc-tablenos

WORKDIR /source

ENTRYPOINT ["/bin/bash"]

CMD ["--help"]