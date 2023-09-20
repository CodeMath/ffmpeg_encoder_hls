#!/bin/bash
BBlack="\033[1;30m"
RED='\033[0;31m'
BRed="\033[1;31m"
Green="\033[0;32m"
BGreen="\033[1;32m"
NC='\033[0m' # No Color

echo ""
echo -e "***** ***** ${BGreen}KEYMAKER PRO${NC} ***** *****"
echo -e "암호화 ${BRed}Key${NC}를 생성할 ${BGreen}파일명${NC} (확장자 제외) 을 입력하세요."
read -p ":" filename_reader
echo ""

while true
do
  read -p "입력한 파일이 ${filename_reader}.mp4 입니다. 맞습니까? Y/n: " checker
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

  file_name="${filename_reader}"
  echo "파일명은 ${file_name}.mp4 입니다."
  i=1
  mkdir key
  
  mkdir key/$file_name

  while true
  do
      tmpfile='mktemp'
      random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 30 | sed 1q)
      openssl rand 16 > key/${file_name}/${random_string}_enc_$i.key
      echo https://cdn.answered.co.kr/vod/${file_name}/key/${file_name}/${random_string}_enc_$i.key > $tmpfile
      echo key/${file_name}/${random_string}_enc_$i.key >> $tmpfile
      echo `openssl rand -hex 16` >> $tmpfile
      mv $tmpfile key/${file_name}/${file_name}_enc.keyinfo
      echo "change key/${file_name}/${random_string}_enc$i.key keyinfo - $i"
      let i++
      sleep 2
  done
else
  echo "파일 명을 입력하시오"
fi
