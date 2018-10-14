FROM jupyter/tensorflow-notebook

ENV JUPYTER_ENABLE_LAB="yes"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    octave \
    octave-symbolic \
    octave-miscellaneous \
    gnuplot \
    ghostscript && \
    apt-get clean && \
    rm -rf  /var/lib/apt/lists/*

USER $NB_UID

RUN conda install --quiet --yes \
    octave_kernel \
    mpld3 && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN pip install SchemDraw control

USER $NB_UID
