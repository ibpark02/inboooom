#!/bin/bash

# 친구 변수 설정
DOCKER_USERNAME="parkinbeom"
IMAGE_NAME="ipark"
TAG="22.04-cpu-auto"
FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME:$TAG"

# 1. 빌드
echo "-------------------------------------"
echo "Building Docker image: $FULL_IMAGE_NAME"
docker build -t $FULL_IMAGE_NAME .

if [ $? -ne 0 ]; then
    echo "ERROR: Build failed."
    exit 1
fi

# 2. 로그인
echo "-------------------------------------"
echo "Logging in..."
docker login

if [ $? -ne 0 ]; then
    echo "ERROR: Login failed."
    exit 1
fi

# 3. 푸시
echo "-------------------------------------"
echo "Pushing image..."
docker push $FULL_IMAGE_NAME

if [ $? -ne 0 ]; then
    echo "ERROR: Push failed."
    exit 1
fi

# 4. [완전 짧아진 실행 명령어 안내]
echo "-------------------------------------"
echo " [배포 완료!]"
echo " 이제 아래 명령어 한 줄이면 끝납니다."
echo ""
echo " docker run --rm -v \$(pwd):/app $FULL_IMAGE_NAME <이미지URL>"
echo ""
echo " (설명: 결과 사진은 현재 폴더에 predictions.jpg로 저장됩니다.)"
echo "-------------------------------------"
