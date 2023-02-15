# Adyen Postman

Icons for external tools (e.g. Travis)

Short description explaining (1) what the repo contains, (2) how it works and (3) why you would need it.

This repository contains declaration files in the [Postman](https://postman.com/) format. The files are automatically generated based on the latest [adyen-openapi](https://github.com/adyen/adyen-openapi) definition files.
They are then uploaded on our [AdyenDev](https://www.postman.com/adyendev/) Postman space and you can fork it from there. You can also directly pick the `.json` files available here and upload them if you prefer.

## Contributing

We encourage you to contribute to our repository. Find out more in our [contribution guidelines](https://github.com/Adyen/.github/blob/master/CONTRIBUTING.md).
However, for anything related to our APIs, the correct repository to contribute to would be [adyen-openapi](https://github.com/adyen/adyen-openapi).

## Usage

* `generateAll.sh` generates all postman API collection files for all versions of the OpenAPI definitions and places them in the postman folder. It is meant to run inside the [dedicated docker image](https://github.com/gcatanese/openapi-generator-postman-v2/).
* `runDocker.sh` is the script that actually runs `generateAll.sh` inside the docker image. 

This step should only be done for initial setup, or if something goes wrong. Most work should be automated in the GitHub workflows.

## Documentation
Link to relevant documentation and next steps that have to be taken.

## Support
If you have a feature request, or spotted a bug or a technical problem, create a GitHub issue. For other questions, contact our [support team](https://www.adyen.help/hc/en-us/requests/new).

## License
MIT license. For more information, see the LICENSE file.