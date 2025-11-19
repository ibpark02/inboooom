set -e

URL=$1
if [ -z "$URL" ]; then
    echo "Error: 이미지 URL을 입력해주세요."
    exit 1
fi

cd /darknet

echo "Downloading image from $URL..."
wget -O input.jpg "$URL" -q

echo "Running YOLOv3 detection..."
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg -dont_show

if [ -f "predictions.jpg" ]; then
    mv predictions.jpg /app/predictions.jpg
    echo "------------------------------------------------"
    echo " 분석 완료! 결과 파일이 현재 폴더(predictions.jpg)에 저장되었습니다."
    echo "------------------------------------------------"
else
    echo "Error: 분석에 실패하여 결과 파일이 생성되지 않았습니다."
    exit 1
fi
