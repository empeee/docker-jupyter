FROM jupyter/tensorflow-notebook:1145fb1198b2

ENV JUPYTER_ENABLE_LAB="yes"

USER root

# Apt installs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    octave=4.2.2-1ubuntu1 \
    octave-symbolic=2.6.0-3build1 \
    octave-miscellaneous=1.2.1-4 \
    gnuplot=5.2.2+dfsg1-2ubuntu1 \
    ghostscript=9.25~dfsg+1-0ubuntu0.18.04.1 \
    liboctave-dev=4.2.2-1ubuntu1 && \
    apt-get clean && \
    rm -rf  /var/lib/apt/lists/*

USER $NB_UID

# Conda installs
RUN conda install --quiet --yes \
    'octave_kernel=0.28.4' \
    'mpld3=0.3' && \
    conda install --quiet --yes -c damianavila82 rise=5.3.0 && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Pip installs
RUN pip install \
    SchemDraw==0.3.1 \
    control==0.8.0

# Labextension install
RUN jupyter labextension install \
    @jupyterlab/toc@0.5.0 \
    jupyterlab-drawio@0.4.0

# Octave installs
RUN octave --eval "pkg install -forge control io statistics"

USER $NB_UID
