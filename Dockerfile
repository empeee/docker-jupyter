FROM jupyter/tensorflow-notebook

#
# root operations
#
USER root

# Apt installs
RUN apt update && \
    apt install -y --no-install-recommends \
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

# PySpice Installs
# PySpice needs to compile from source as far as I can tell to get libngspice.so
RUN wget http://sourceforge.net/projects/ngspice/files/ng-spice-rework/31/ngspice-31.tar.gz && \
    tar xvzf ngspice-31.tar.gz && \
    rm ngspice-31.tar.gz && \
    cd ngspice-31 && \
    ./configure --with-ngshared \
        --prefix=/usr/local \
        --enable-xspice \
        --disable-debug \
        --enable-cider \
        --with-readline=yes \
        --enable-openmp && \
    make && \
    make install && \
    cd .. && \
    rm -rf ngspice-31

#
# user operations
#
USER $NB_UID

# Conda installs
RUN conda install --quiet --yes \
    octave_kernel \
    mpld3 && \
    conda install --quiet --yes -c conda-forge rise && \
    conda clean -afy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Pip installs
RUN pip install \
    SchemDraw \
    control \
    lcapy \
    pyspice

# Labextension install
RUN jupyter labextension install \
    @jupyterlab/toc
#    jupyterlab_vim

# Octave installs
RUN octave --eval "pkg install -forge control io statistics"

# Set environmental variables
ENV JUPYTER_ENABLE_LAB="yes"
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
