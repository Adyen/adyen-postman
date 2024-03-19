#!/bin/sh

# Sets working tools
if [[ $OSTYPE == 'darwin'* ]]; then
  echo "MacOS detected. Alias sed to gsed."
  alias sed=gsed
fi

DATE=$(date +"%Y-%m-%d")
# We allow only non classic, non webhook APIs
ALLOW_LIST="BalanceControlService|BalancePlatformService|BinLookupService|CheckoutService|DataProtectionService|DisputeService|GrantService|LegalEntityService|ManagementService|PayoutService|RecurringService|StoredValueService|TestCardService|TfmAPIService|TransferService"

for entry in "adyen-openapi/json"/*
do
  echo "Processing $entry"
  if echo "$entry" | grep -q -E "$ALLOW_LIST"; then
    echo "$entry is part of the allow list. Generating"
    FILENAME=$entry
    BASE=$(echo "$(basename "${FILENAME%.*}")")
    NAME=$(echo $FILENAME | sed 's/-.*//' | sed 's/.*\///')
    REAL_NAME=$(sed '/title:/!d;q' $FILENAME | sed 's/.*://')
    VERSION=$(echo $FILENAME | sed 's/.*-v//' | sed 's/\..*//')

    #  echo "Generating $FILENAME $BASE $NAME $REAL_NAME $VERSION $DATE"

    sed -i.bak2 "0,/title:.*/{s//title: $REAL_NAME\ (v$VERSION)/}" $FILENAME # Set unique name of API for Postman

    /script.sh generate \
        --additional-properties postmanVariables=YOUR_MERCHANT_ACCOUNT-YOUR_COMPANY_ACCOUNT-YOUR_BALANCE_PLATFORM,generatedVariables=YOUR_REFERENCE_NUMBER-YOUR_REFERENCE-YOUR_ORDER_NUMBER-YOUR_ORDER_NUMBER\
        -i $FILENAME \
        -o postman/$BASE

    mv postman/$BASE/postman.json postman/$BASE.json
    rm -rf postman/$BASE
  else
    echo "$entry is NOT part of the allow list. Skipping"
  fi
done
