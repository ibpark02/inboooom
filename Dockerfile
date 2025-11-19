FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential cmake git wget pkg-config ca-certificates \
    libgtk-3-dev libopencv-dev libgflags-dev libgtest-dev \
    dos2unix && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /darknet

RUN git config --global http.sslVerify false && \
    git clone https://github.com/pjreddie/darknet.git . && \
    sed -i 's/OPENCV=1/OPENCV=0/' Makefile && \
    sed -i 's/GPU=1/GPU=0/' Makefile && \
    sed -i 's/CUDNN=1/CUDNN=0/' Makefile && \
    make

RUN wget -q https://pjreddie.com/media/files/yolov3.weights
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
