# 친구의 선택: Ubuntu 22.04
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. 패키지 설치 (친구 스타일 유지)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential cmake git wget pkg-config ca-certificates \
    libgtk-3-dev libopencv-dev libgflags-dev libgtest-dev \
    dos2unix && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /darknet

# 2. Darknet 설치 및 설정 (OPENCV=0 필수)
RUN git config --global http.sslVerify false && \
    git clone https://github.com/pjreddie/darknet.git . && \
    sed -i 's/OPENCV=1/OPENCV=0/' Makefile && \
    sed -i 's/GPU=1/GPU=0/' Makefile && \
    sed -i 's/CUDNN=1/CUDNN=0/' Makefile && \
    make

# 3. 가중치 파일 미리 다운로드
RUN wget -q https://pjreddie.com/media/files/yolov3.weights

# 4. [핵심] 실행 스크립트 복사 및 권한 부여
# 방금 만든 entrypoint.sh를 컨테이너 안으로 복사합니다.
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

# 5. 작업 경로 설정 (/app에 결과물 저장)
WORKDIR /app

# 6. [핵심] 컨테이너 실행 시 자동으로 스크립트 가동
ENTRYPOINT ["/entrypoint.sh"]
