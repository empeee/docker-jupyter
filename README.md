# docker-jupyter-lab
My custom docker for a Jupyter server.
## Usage
```
docker create \
  --name=jupyter \
    -v <path to notebooks>:/home/jovyan/work \
    -v <path to config>:/home/jovyan/.jupyter \
    -p 8888:8888 \
  empeee/jupyter
```
## Custom Packages
This is built off of the [Jupyter Notebook Deep Learning Stack](https://github.com/jupyter/docker-stacks/tree/master/tensorflow-notebook) and includes an Octave kernel and several custom packages listed below.
  * [SchemDraw](https://cdelker.bitbucket.io/SchemDraw/SchemDraw.html) - Python-based schematic drawing tool
  * [python-control](http://python-control.readthedocs.io/en/latest/index.html) - Python control systems library
  * [TensorFlow](https://www.tensorflow.org) - Open source software library for high performance numerical computation
  * [mpld3](http://mpld3.github.io/) - Bringing Matplotlib to the Browser
  * [lcapy](http://lcapy.elec.canterbury.ac.nz/index.html) - Python package for linear circuit analysis
