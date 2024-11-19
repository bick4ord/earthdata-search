#!/bin/bash -ex

BUCKET=${1}

function s3_copy {
       aws s3 cp \
              ./website \
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
