#!/bin/sh

# Update an existing Postman collection from a given OpenAPI file
#
# updateCollection.sh <filename> <postman api key> <postman collection id> 
#

# Sets working tools
if [[ $OSTYPE == 'darwin'* ]]; then
  echo "MacOS detected. Alias sed to gsed."
  alias sed=gsed
fi

DATE=$(date +"%Y-%m-%d")

echo "Updating Postman Collection..."
FILENAME=$1
POSTMAN_API_KEY=$2
POSTMAN_COLLECTION_ID=$3

echo "FILENAME: $FILENAME"
echo "POSTMAN_API_KEY: #####"
echo "POSTMAN_COLLECTION_ID: $POSTMAN_COLLECTION_ID"

BASE=$(echo "$(basename "${FILENAME%.*}")")
NAME=$(echo $FILENAME | sed 's/-.*//' | sed 's/.*\///')
REAL_NAME=$(sed '/title:/!d;q' $FILENAME | sed 's/.*://')
VERSION=$(echo $FILENAME | sed 's/.*-v//' | sed 's/\..*//')

#  echo "Generating $FILENAME $BASE $NAME $REAL_NAME $VERSION $DATE"

sed -i.bak "1s/.*/openapi: 3.0.3/" $FILENAME # downgrade version for compat
sed -i.bak2 "0,/title:.*/{s//title: $REAL_NAME\ (v$VERSION)/}" $FILENAME # Set unique name of API for Postman

# set Postman API key as env variable
export POSTMAN_API_KEY

/script.sh generate \
    --additional-properties postmanVariables=YOUR_MERCHANT_ACCOUNT-YOUR_COMPANY_ACCOUNT-YOUR_BALANCE_PLATFORM,generatedVariables=YOUR_REFERENCE_NUMBER-YOUR_REFERENCE-YOUR_ORDER_NUMBER-YOUR_ORDER_NUMBER\
    -i $FILENAME \
    -o postman/$BASE

mv postman/$BASE/postman.json postman/$BASE.json
rm -rf postman/$BASE

echo "Generated postman/$BASE.json"

# push to Postman (PUT)
echo "--> Pushing to Postman"

var=$(cat "postman/$BASE.json")

echo '{"collection": '"$var"' }' | curl -X PUT \
--header 'Content-Type: application/json' \
--header 'X-API-Key: '"${POSTMAN_API_KEY}"'' \
-d @- "https://api.getpostman.com/collections/$POSTMAN_COLLECTION_ID"