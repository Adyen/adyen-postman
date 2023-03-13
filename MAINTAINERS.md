# How to run this code and contribute

__NOTE : This part is meant for the authors of that repository and you probably shouldn't be doing it :)__.

## Setup

Most of the magic here resides in the [trigger-postman.yml](./.github/workflows/trigger-postman.yml) workflow.
This workflow can either be triggered [directly from the UI](![Variables to set in my collection](./images/collection-variables.png).
), though typically it is automatically triggered every time the [adyen-openapi](https://github.com/Adyen/adyen-openapi/blob/main/.github/workflows/notify.yml) repository is updated.


It relies on two different custom actions : 

* The [openapi-generator-postman-v2](https://github.com/gcatanese/openapi-generator-postman-v2) which is used to transform OpenAPI specifications into a Postman compatible format.
* The [push-adyen-collections-to-postman-javascript-action](https://github.com/jlengrand/push-adyen-collections-to-postman-javascript-action/) which uses the Postman API to push those files to the [Postman AdyenDev workspace](https://www.postman.com/adyendev/workspace/adyen-apis/overview).


## Workflow (see [trigger-postman.yml](./.github/workflows/trigger-postman.yml))

When the workflow gets triggered :

* The `issue` job will be fired. It is meant to warn us something needs to be checked.
    * This job checks what new files have been created in the adyen-openapi repository
    * Creates a [GitHub issue](https://github.com/Adyen/adyen-postman/issues) with the list of those files and assigns it to us. 
* The `generate` job will be fired
    * This job first runs a script relying on [openapi-generator-postman-v2](https://github.com/gcatanese/openapi-generator-postman-v2). This script will take each yaml file in the adyen-openapi repository and generate a corresponding Postman compatible version from them.
        * The `generateAll.sh` script contains an `ALLOW_LIST` that lists all APIs that should **NOT** be ignored. Everything else (classic, webhooks, newer APIs), is ignored by default.
        *  The `generateAll.sh` script also contains a list of `postmanVariables` and `generatedVariables` that are needed to create the variables in the Postman format.
    * All files which have changed (been modified, or added) are then committed to the repository. 
    * Then, the [push-adyen-collections-to-postman-javascript-action](https://github.com/jlengrand/push-adyen-collections-to-postman-javascript-action/) action will be run. This action : 
        * Takes all Postman files in the repository
        * Finds the highest version of each file for each API 
        * If a new API is detected, uploads it to the AdyenDev workspace as a new collection
        * If a newer version of an existing API is detected, patches the existing collection to the newer version

## Repository secrets
 
Two repository secrets are necessary to successfully run this action : 

* POSTMAN_API_KEY : The API Key that will be used to interact with Postman (to push collections).
* POSTMAN_WORKSPACE_ID : The workspace where collections will be pushed / updated.

## Scripts

Two custom scripts are present in the repository

* `generateAll.sh` generates all postman API collection files for all versions of the OpenAPI definitions and places them in the postman folder. It is meant to run inside the [dedicated docker image](https://github.com/gcatanese/openapi-generator-postman-v2/).
* `runDocker.sh` is the script that actually runs `generateAll.sh` inside the docker image. 

## Running locally

If necessary, the scripts can be run locally to achieve the same results. 

* To generate Postman JSON files, one can run the `runDocker.sh` script. (Docker needs to be installed and started). 
    * Once the generation is done, the updated files can be committed.
* To push the collections to Postman, see the documentation of [push-adyen-collections-to-postman-javascript-action/](https://github.com/jlengrand/push-adyen-collections-to-postman-javascript-action/).

Note that both scripts _should_ be safe to run without issues . The generation can be reversed via git, and you can use a dummy workspace ID for the postman script to push to a safe place for testing.

## Contact

For help, contact @jlengrand or @gcatanese