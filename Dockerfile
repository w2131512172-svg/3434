FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && \
    apt-get install -y \
    git \
    wget \
    aria2 \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.10 + pip
RUN apt-get update && \
    apt-get install -y python3.10 python3.10-distutils python3-pip && \
    ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Install PyTorch CUDA 12.1 stack
RUN pip install torch==2.5.1+cu121 \
    torchvision==0.20.1+cu121 \
    torchaudio==2.5.1+cu121 \
    --index-url https://download.pytorch.org/whl/cu121

# Install xformers
RUN pip install xformers==0.0.27.post2

# Install JupyterLab
RUN pip install jupyterlab

WORKDIR /workspace

EXPOSE 8888
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
