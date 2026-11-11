  #!/bin/sh

if [ ! -d /adyen-openapi ]; then
  git clone https://github.com/Adyen/adyen-openapi.git
fi

docker run --volume $(pwd):/usr/src/app --entrypoint /usr/src/app/generateAll.sh ghcr.io/adyen-examples/openapi-generator-postman-v2:main

# clean up
rm -rf adyen-openapi