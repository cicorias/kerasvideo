#base image provides CUDA support on Ubuntu 16.04
FROM nvidia/cuda:8.0-cudnn6-devel

#package updates to support conda
RUN apt-get update && \
    apt-get install -y wget git libhdf5-dev g++ graphviz

ENV CONDA_DIR /home/keris/.conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV NB_USER keras
ENV NB_UID 1000

RUN useradd -m -s /bin/bash -b /home -N -u $NB_UID $NB_USER

RUN mkdir -p $CONDA_DIR && \
    chown keras $CONDA_DIR

#setting up a user to run conda
RUN mkdir -p /home/keras/src && \
    chown keras /home/keras/src

USER keras

#add on conda python and make sure it is in the path
RUN mkdir -p $CONDA_DIR && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' >> /home/keras/.bashrc  && \
    wget --quiet --output-document=/home/keras/anaconda.sh https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh && \
    /bin/bash /home/keras/anaconda.sh -f -b -p $CONDA_DIR
    #rm anaconda.sh



RUN echo "hellow"

#conda installing python, then tensorflow and keras for deep learning
RUN conda install -y python=3.6 && \
    pip install --upgrade pip && \
    pip install --upgrade tensorflow && \
    pip install --upgrade keras && \
    conda clean -yt

#all the code samples for the video series
VOLUME ["/src"]

#serve up a jupyter notebook 
USER keras
WORKDIR /src
EXPOSE 8888
CMD jupyter notebook --port=8888 --ip=0.0.0.0
