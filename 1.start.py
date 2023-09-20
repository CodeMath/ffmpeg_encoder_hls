import uuid
import os
import shutil
import time

# 1. UUID 파일 이름 생성
def generate_uuid():
    return uuid.uuid4()

# 초기화
names = generate_uuid()

# 2. 파일 이름 UUID 로 변경하며 COPY
def generate_file_uuid():
    init_file = input("파일 이름을 입력하세요(확장자 제외): ")
    shutil.copy(
        os.getcwd()+'/{}.mp4'.format(init_file),
        os.getcwd()+'/{}.mp4'.format(names)
    )
    try:
        shutil.copy(
            os.getcwd()+'/{}.vtt'.format(init_file),
            os.getcwd()+'/{}.vtt'.format(names)
        )
    except:
        print("\n>>>>> [ERROR] 자막 파일이 없습니다. \n\n")
        
    print(names, "mp4 파일 변환되었습니다.\n\n* 10초 뒤 자동 종료됩니다.")
    time.sleep(10)

generate_file_uuid()