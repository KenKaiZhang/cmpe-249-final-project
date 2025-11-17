# Use NVIDIA Vulkan base image as specified for CARLA compatibility
FROM nvidia/cuda:11.4.3-cudnn8-runtime-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV CUDA_VERSION=10.1
ENV TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6"
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN rm -f /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list || true

# Install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    curl \
    git \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    libffi-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    liblzma-dev \
    python3-pip \
    python3-dev \
    python3-setuptools \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    unzip \
    vim \
    htop \
    tmux \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.8 (required for TransFuser compatibility)
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.8 python3.8-dev python3.8-distutils && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    curl https://bootstrap.pypa.io/pip/3.8/get-pip.py | python3

# Install conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    $CONDA_DIR/bin/conda clean -afy

# Set working directory
WORKDIR /workspace

COPY . .

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
    
RUN conda env create -f environment.yml

ENV PATH /opt/conda/envs/tfuse/bin:$PATH

# Install torch-scatter for TransFuser
RUN pip3 install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113 && \
    pip3 install -U openmim && \
    mim install mmcv-full==1.6.0 && \
    pip3 install torch-scatter -f https://data.pyg.org/whl/torch-1.12.1+cu113.html

# Create necessary directories
RUN mkdir -p /workspace/logs /workspace/checkpoints

# Set up display for GUI applications (if needed)
ENV DISPLAY=:0

# Expose ports for various services
EXPOSE 2000 2001 2002 6006 8888

CMD ["bash"]