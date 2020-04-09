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
    @jupyterlab/toc
#    jupyterlab_vim
#    jupyterlab-drawio

# Octave installs
RUN octave --eval "pkg install -forge control io statistics"

# PySpice Installs
# PySpice needs to compile from source as far as I can tell to get libngspice.so
USER root
RUN wget http://sourceforge.net/projects/ngspice/files/ng-spice-rework/31/ngspice-31.tar.gz; tar xvzf ngspice-31.tar.gz; rm ngspice-31.tar.gz
RUN cd ngspice-31; ./configure --with-ngshared; make; make install
RUN rm -rf ngspice-31

# Pip install PySpice and update LD_LIBRARY_PATH so python can find the shared library
USER $NB_UID
RUN pip install pyspice
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

USER $NB_UID
