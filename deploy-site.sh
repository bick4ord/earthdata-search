#!/bin/bash -ex

BUCKET=${1}

rm -rf static/dist
mkdir -p static/dist

docker run -it \
  --platform linux/amd64 \
  --entrypoint '' \
  -v $(pwd)/static:/static earthdata-search:deploy \
  bash -exc "cp -r /build/static/dist/* /static/dist"

function s3_copy {
       if [ "${3}" == "" ]; then
         dir=dist
       else
         dir=${3}
       fi
       aws s3 cp \
              ./static/${dir}\
              s3://${BUCKET}/ \
              --exclude '*' \
              --include "*.${1}" \
              --no-guess-mime-type \
              --content-type="${2}" \
              --metadata-directive="REPLACE" \
              --recursive
}

s3_copy html "text/html; charset=utf-8"
s3_copy js "text/javascript; charset=utf-8"
s3_copy png image/png
s3_copy svg image/svg+xml
s3_copy css "text/css; charset=utf-8"
s3_copy ico image/x-icon src/public
