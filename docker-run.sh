#!/bin/bash

docker run --rm --name=jupyter -d -p 9999:8888 -v /home/mark/tmpconfig:/home/jovyan/.jupyter -v /home/mark/tmpnotebook:/home/jovyan/work empeee/jupyter
