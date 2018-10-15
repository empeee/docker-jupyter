FROM jupyter/tensorflow-notebook:1145fb1198b2

ENV JUPYTER_ENABLE_LAB="yes"

USER root

# Apt installs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    octave \
    octave-symbolic \
    octave-miscellaneous \
    gnuplot \
    ghostscript \
    liboctave-dev && \
    apt-get clean && \
    rm -rf  /var/lib/apt/lists/*

USER $NB_UID

# Conda installs
RUN conda install --quiet --yes \
    'octave_kernel=0.28.4' \
    'mpld3=0.3' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Pip installs
RUN pip install SchemDraw control

# Labextension install
RUN jupyter labextension install \
    @jupyterlab/toc@0.5.0 \
    jupyterlab-drawio@0.4.0

# Octave installs
RUN octave --eval "pkg install -forge control io statistics"

USER $NB_UID
