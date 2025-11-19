#!/bin/bash
set -e

# 1. URL 입력 확인
URL=$1
if [ -z "$URL" ]; then
    echo "Error: 이미지 URL을 입력해주세요."
    exit 1
fi

# [핵심 수정] 2. 실행 위치를 Darknet 폴더로 이동
# 이유: 그래야 data/coco.names 파일을 찾을 수 있습니다.
cd /darknet

# 3. 이미지 다운로드
echo "Downloading image from $URL..."
wget -O input.jpg "$URL" -q

# 4. YOLO 실행
# 이제 /darknet 폴더 안에 있으므로 경로 에러가 안 납니다.
echo "Running YOLOv3 detection..."
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg -dont_show

# 5. 결과 파일 이동 (/app 폴더로)
# 결과물(predictions.jpg)을 사용자가 볼 수 있게 마운트된 폴더로 옮깁니다.
if [ -f "predictions.jpg" ]; then
    mv predictions.jpg /app/predictions.jpg
    echo "------------------------------------------------"
    echo " 분석 완료! 결과 파일이 현재 폴더(predictions.jpg)에 저장되었습니다."
    echo "------------------------------------------------"
else
    echo "Error: 분석에 실패하여 결과 파일이 생성되지 않았습니다."
    exit 1
fi
