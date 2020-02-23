FROM ubuntu:18.04 as pandoc-builder

MAINTAINER Bogi Napoleon Wennerstrøm <bogi.wennerstrom@gmail.com>

RUN apt-get update

# install essentials
RUN apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
    software-properties-common \
    pkg-config \
    build-essential \
    make \
    zlib1g-dev \
    wget

# install latex packages
RUN apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
    lmodern \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-generic-extra \
    texlive-science \
    texlive-bibtex-extra \
    fontconfig \
    python-dev \
    python-pip \
    aspell \
    aspell-en \
    unzip

# setup python
RUN wget https://bootstrap.pypa.io/ez_setup.py -O - | python
RUN pip2 install setuptools 
RUN pip2 install wheel 
RUN pip2 install pandocfilters

# install pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/2.9.1.1/pandoc-2.9.1.1-1-amd64.deb
RUN apt-get install -y ./pandoc-2.9.1.1-1-amd64.deb
RUN rm pandoc-2.9.1.1-1-amd64.deb

# install crossref
RUN wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.6.1b/linux-pandoc_2_9_1_1.tar.gz
RUN tar -xvf linux-pandoc_2_9_1_1.tar.gz
RUN mv pandoc-crossref /usr/bin/
RUN rm linux-pandoc_2_9_1_1.tar.gz

# setup python filters
RUN pip install pandoc-fignos
RUN pip install pandoc-eqnos
RUN pip install pandoc-tablenos

# Get some more filters
WORKDIR /filters
RUN wget https://github.com/pandoc/lua-filters/archive/master.zip
RUN unzip master.zip
RUN rm master.zip
RUN mv lua-filters-master/* .
RUN rm -r lua-filters-master
RUN wget https://github.com/01mf02/pandocfilters/archive/master.zip
RUN unzip master.zip
RUN rm master.zip
RUN mv pandocfilters-master/* .
RUN rm -r pandocfilters-master

# Cleanup unused dependencies
RUN apt-get remove -y wget unzip
RUN apt-get autoremove -y

WORKDIR /source

ENTRYPOINT ["/bin/bash"]

CMD ["--help"]