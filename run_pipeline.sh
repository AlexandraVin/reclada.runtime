#!/bin/bash

_S3_FILE_URI="$1"
_JOB_ID="$2"
_INPUT_DIR="/mnt/input/${_JOB_ID}"
_OUTPUT_DIR="/mnt/output/${_JOB_ID}"

DB_URI_QUOTED=`python3 -c "import urllib.parse; parsed = urllib.parse.urlparse('$DB_URI'); print('$DB_URI'.replace(parsed.password, urllib.parse.quote(parsed.password)))"`
S3_FILE_NAME=`python3 -c "print('$_S3_FILE_URI'.split('/')[-1])"`

aws s3 cp "${_S3_FILE_URI}" "${_INPUT_DIR}/${S3_FILE_NAME}"

python3 -m table_extractor.run run "${_INPUT_DIR}/${S3_FILE_NAME}" "${_OUTPUT_DIR}" --verbose true --paddle_on true

python3 -m bd2reclada "${_OUTPUT_DIR}/${S3_FILE_NAME}/document.json" "${_OUTPUT_DIR}/output.csv"
cat "${_OUTPUT_DIR}/output.csv" | psql ${DB_URI_QUOTED} -c "\COPY reclada.staging FROM STDIN WITH CSV QUOTE ''''"

python3 -m lite "${_OUTPUT_DIR}/output.csv" "${_OUTPUT_DIR}/nlp_output.csv"
cat "${_OUTPUT_DIR}/nlp_output.csv" | psql ${DB_URI_QUOTED} -c "\COPY reclada.staging FROM STDIN WITH CSV QUOTE ''''"

aws s3 cp "${_OUTPUT_DIR}" "s3://${AWS_S3_BUCKET_NAME}/output/${_JOB_ID}" --recursive
