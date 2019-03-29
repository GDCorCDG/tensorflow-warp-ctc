FROM nvidia/cuda:9.0-base-ubuntu16.04

LABEL maintainer="Craig Citro <craigcitro@google.com>"

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        python3-setuptools \
        cmake \
        python3-dev \
        build-essential \
        cuda-command-line-tools-9-0 \
        cuda-cublas-9-0 \
        cuda-cufft-9-0 \
        cuda-curand-9-0 \
        cuda-cusolver-9-0 \
        cuda-cusparse-9-0 \
        python3-pip \
        curl \
        libcudnn7=7.2.1.38-1+cuda9.0 \
        libnccl2=2.2.13-1+cuda9.0 \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
        apt-get install nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0 && \
        apt-get update && \
        apt-get install libnvinfer4=4.1.2-1+cuda9.0

RUN pip3 --no-cache-dir install \
        Pillow \
        h5py \
        keras_applications \
        keras_preprocessing \
        matplotlib \
        numpy \
        pandas \
        scipy \
        sklearn
RUN pip3 install --upgrade setuptools 
# --- DO NOT EDIT OR DELETE BETWEEN THE LINES --- #
# These lines will be edited automatically by parameterized_docker_build.sh. #
# COPY _PIP_FILE_ /
# RUN pip3 --no-cache-dir install /_PIP_FILE_
# RUN rm -f /_PIP_FILE_

# Install TensorFlow GPU version.
RUN pip3 --no-cache-dir install \
        'git+https://github.com/tensorpack/tensorpack.git' \
        'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI' \
        tensorflow-gpu==1.12.0 
# --- ~ DO NOT EDIT OR DELETE BETWEEN THE LINES --- #

RUN ln -s  /usr/local/cuda-9.0/lib64/libcurand.so.9.0 \
        /usr/local/cuda-9.0/lib64/libcurand.so

WORKDIR "/opt"

ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

# RUN ln -s -f /usr/bin/python3 /usr/bin/python#
RUN git  clone https://github.com/HawkAaron/warp-ctc.git && \
        cd warp-ctc && mkdir build && cd build && \
        cmake .. && make && \
        cd ../tensorflow_binding && \
        python3 setup.py install && \
        rm -rf /opt/warp-ctc
# Set up our notebook config.


CMD ["/bin/bash"]
