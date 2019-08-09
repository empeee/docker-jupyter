FROM jupyter/tensorflow-notebook

ENV JUPYTER_ENABLE_LAB="yes"

USER root

# Apt installs
RUN apt update && \
    apt install -y \
    octave \
    octave-symbolic \
    octave-miscellaneous \
    gnuplot \
    ghostscript \
    liboctave-dev \
    texlive-latex-base \
    texlive-pictures \
    texlive-latex-extra \
    imagemagick \
    libjs-mathjax \
    fonts-mathjax \
    poppler-utils && \
    apt clean && \
    rm -rf  /var/lib/apt/lists/*

USER $NB_UID

# Conda installs
RUN conda install --quiet --yes \
    octave_kernel \
    mpld3 && \
    conda install --quiet --yes -c conda-forge rise && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Pip installs
RUN pip install \
    SchemDraw \
    control \
    lcapy

# Labextension install
RUN jupyter labextension install \
    @jupyterlab/toc \
    jupyterlab-drawio

# Octave installs
RUN octave --eval "pkg install -forge control io statistics"

USER $NB_UID
