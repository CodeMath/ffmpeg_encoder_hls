#!/bin/bash
BBlack="\033[1;30m"
RED='\033[0;31m'
BRed="\033[1;31m"
Green="\033[0;32m"
BGreen="\033[1;32m"
NC='\033[0m' # No Color

echo ""
echo -e "***** ***** ${BGreen}ENCODER PRO${NC} ***** *****"
echo -e "암호화 ${BRed}화질 인코딩${NC}을 생성할 ${BGreen}파일명${NC} (확장자 제외) 을 입력하세요."
read -p ": " filename_reader
echo ""

while true
do
  read -p "입력한 파일이 ${filename_reader}.mp4, ${filename_reader}.vtt 입니다. 맞습니까? Y/n: " checker
  if [ $checker == "Y" ]
  then
      break
  fi

  if [ $checker == "n" ]
  then
      break
  fi
done

if [ $checker == "Y" ]
then

  file_name="${filename_reader}.mp4"

  echo -e "ts 파일을 만듭니다. ${BGreen}SD, HD, FHD${NC} 화질"
  echo -e "${BRed}$1${NC} 랜더링 시작합니다."

  ffmpeg -i ${filename_reader}.mp4 \
    -preset veryfast -threads 0 \
    -map 0:v:0 -map '0:a:0' -map 0:v:0 -map '0:a:0' -map 0:v:0 -map '0:a:0' -map 0:v:0 -map '0:a:0'\
    -c:v libx264 -crf 22 -c:a aac -ar 48000 \
    -filter:v:0 scale=-2:360:force_original_aspect_ratio=decrease  -maxrate:v:0 600k -b:a:0 64k \
    -filter:v:1 scale=-2:720:force_original_aspect_ratio=decrease  -maxrate:v:1 900k -b:a:1 128k \
    -filter:v:2 scale=-2:1080:force_original_aspect_ratio=decrease -maxrate:v:2 900k -b:a:2 128k \
    -filter:v:3 scale=-2:2160:force_original_aspect_ratio=decrease -maxrate:v:3 900k -b:a:3 128k \
    -f hls -hls_time 10 -hls_list_size 0 -hls_playlist_type vod\
    -hls_key_info_file "key/${filename_reader}/${filename_reader}_enc.keyinfo"\
    -hls_flags periodic_rekey \
    -hls_segment_type mpegts \
    -var_stream_map "v:0,a:0,name:360p v:1,a:1,name:720p v:2,a:2,name:1080p v:3,a:3,name:2160p" \
    -master_pl_name "master_player.m3u8" \
    -hls_segment_filename "render_%v/file_%03d.ts" "render_%v/index.m3u8"
    #  -progress - -nostats -v quiet
  echo -e "${BRed}화질 랜더링 작업 종료${NC} >>> ${BRed}5초 후 종료됩니다.${NC}"
  
  sleep 5

    # -hls_key_info_file "key/${filename_reader}/${filename_reader}_enc.keyinfo"\
    # -hls_flags periodic_rekey \

#   echo -e "${BGreen}자막 작업${NC}"
#   ./packager.exe \
#     in=${filename_reader}.vtt,stream=text,segment_template=render_text/'$Number$'.vtt,playlist_name=render_text/main.m3u8,hls_group_id=text,hls_name=KOREAN  \
#     --hls_master_playlist_output temp_vtt.txt

#   vtt_file="temp_vtt.txt"
#   nth=1
#   while read line; do
#     echo $line
#     if [ $nth -gt 3 ];then
#         echo "$line" >> master_player.m3u8
#     fi
#   nth=$(($nth+1))
#   done < $vtt_file

#   rm temp_vtt.txt
#   echo -e "${BRed}자막 작업 종료${NC}"
# else
#   echo "파일 명을 입력하시오"
fi