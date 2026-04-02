#!/bin/sh

#  ci_post_clone.sh
#  jjanpot
#
#  Created by 임주희 on 4/3/26.
#  


#!/Volumes/workspace/repository/ci_scripts/ci_post_clone.sh

# 현재 위치를 프로젝트 루트로 이동
cd ..

# 1. 빈 Secrets.xcconfig 파일을 생성해서 Xcode를 안심시킴
touch Secrets.xcconfig

# 2. (선택사항) 만약 환경변수를 Xcode Cloud 설정에 등록했다면 파일에 써줍니다.
# 예: Xcode Cloud Environment Variable에 API_KEY를 등록했을 경우
echo "API_KEY = $API_KEY" >> Secrets.xcconfig

echo "✅ Secrets.xcconfig 파일 생성 완료!"
