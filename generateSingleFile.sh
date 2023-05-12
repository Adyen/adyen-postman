#!/bin/sh

# Generate Postman Collection from a given OpenAPI file
#

# Sets working tools
if [[ $OSTYPE == 'darwin'* ]]; then
  echo "MacOS detected. Alias sed to gsed."
  alias sed=gsed
fi

DATE=$(date +"%Y-%m-%d")

echo "Generate Postman Collection from $1"
FILENAME=$1
BASE=$(echo "$(basename "${FILENAME%.*}")")
NAME=$(echo $FILENAME | sed 's/-.*//' | sed 's/.*\///')
REAL_NAME=$(sed '/title:/!d;q' $FILENAME | sed 's/.*://')
VERSION=$(echo $FILENAME | sed 's/.*-v//' | sed 's/\..*//')

#  echo "Generating $FILENAME $BASE $NAME $REAL_NAME $VERSION $DATE"

sed -i.bak "1s/.*/openapi: 3.0.3/" $FILENAME # downgrade version for compat
sed -i.bak2 "0,/title:.*/{s//title: $REAL_NAME\ (v$VERSION)/}" $FILENAME # Set unique name of API for Postman

/script.sh generate \
    --additional-properties postmanVariables=YOUR_MERCHANT_ACCOUNT-YOUR_COMPANY_ACCOUNT-YOUR_BALANCE_PLATFORM,generatedVariables=YOUR_REFERENCE_NUMBER-YOUR_REFERENCE-YOUR_ORDER_NUMBER-YOUR_ORDER_NUMBER\
    -i $FILENAME \
    -o postman/$BASE

mv postman/$BASE/postman.json postman/$BASE.json
rm -rf postman/$BASE