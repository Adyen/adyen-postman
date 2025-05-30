# How to run this code and contribute

__NOTE : This part is meant for the authors of that repository and you probably shouldn't be doing it :)__.

## Setup

Most of the magic here resides in the [trigger-postman.yml](./.github/workflows/trigger-postman.yml) workflow.
This workflow can either be triggered [directly from the UI](https://github.com/Adyen/adyen-postman/actions/workflows/trigger-postman.yml), though typically it is automatically triggered every time the [adyen-openapi](https://github.com/Adyen/adyen-openapi/blob/main/.github/workflows/notify.yml) repository is updated.

Othew workflows are provided for 'ad-hoc' operations:
* [generate.yml](./.github/workflows/generate.yml) is provided to generate a Postman JSON file from an OpenAPI file
* [create-collection.yml](./.github/workflows/create-collection.yml) is provided to create (POST) a new collection in Postman.com
* [update-collection.yml](./.github/workflows/update-collection.yml) is provided to update (PUT) an existing collection in Postman.com


The workflows rely on different custom actions : 

* The [openapi-generator-postman-v2](https://github.com/gcatanese/openapi-generator-postman-v2) which is used to transform OpenAPI specifications into a Postman compatible format.
* The [push-to-postman-action](https://github.com/gcatanese/push-to-postman-action) that pushes a single file to Postman.com.


## Workflow trigger-postman (see [trigger-postman.yml](./.github/workflows/trigger-postman.yml))

When the workflow gets triggered :

* The `generate` job will be fired
    * This job first runs a script relying on [openapi-generator-postman-v2](https://github.com/gcatanese/openapi-generator-postman-v2). This script will take each yaml file in the adyen-openapi repository and generate a corresponding Postman compatible version from them.
        * The `generateAll.sh` script contains an `ALLOW_LIST` that lists all APIs that should **NOT** be ignored. Everything else (classic, webhooks, newer APIs), is ignored by default.
        *  The `generateAll.sh` script also contains a list of `postmanVariables` and `generatedVariables` that are needed to create the variables in the Postman format.
    * All files which have changed (been modified, or added) are then committed to the repository. 

## Workflow sync-collections (see [sync-collections.yml](./.github/workflows/sync-collections.yml))

It runs weekly and performs an update of each collection. The collections to update (including the Postman json file and the Collection id) are listed sequentially in the workflow file.

## Workflow generate (see [generate.yml](./.github/workflows/generate.yml))

It requires 1 input variable: **file** (OpenAPI file path within the `adyen-openapi` repository).

The workflow can be executed manually (on-demand) and will perform the following:
* generate the Postman collection (as JSON file)
* commit Postman JSON into the repository

The `generatePostmanJsonFile.sh` script contains a list of `postmanVariables` and `generatedVariables` that are needed to create the variables in the Postman format.

This job first runs a script relying on [openapi-generator-postman-v2](https://github.com/gcatanese/openapi-generator-postman-v2). 

## Workflow create-collection (see [create-collection.yml](./.github/workflows/create-collection.yml))

It requires 2 input variables: **file** (OpenAPI file path within the `adyen-openapi` repository) and **workspaceId** (Postman workspace ID where the collection will be created).

The workflow can be executed manually (on-demand) and will perform the following:
* push (POST) the Postman JSON file to Postman.com


## Workflow update-collection (see [update-collection.yml](./.github/workflows/update-collection.yml))

It requires 2 input variables: **file** (OpenAPI file path within the `adyen-openapi` repository) and **collectionId** (ID of the Postman collection to be updated).

The workflow can be executed manually (on-demand) and will perform the following:
* push (PUT) the Postman JSON file to Postman.com


## Repository secrets
 
Two repository secrets are necessary to successfully run this action : 

* POSTMAN_API_KEY : The API Key that will be used to interact with Postman (to push collections).
* POSTMAN_WORKSPACE_ID : The workspace where collections will be pushed / updated.

## Scripts

The repository includes multiple scripts:

* `generateAll.sh` (*) generates all postman API collection files for all versions of the OpenAPI definitions and places them in the postman folder. It is meant to run inside the [dedicated docker image](https://github.com/gcatanese/openapi-generator-postman-v2/).
* `runDocker.sh` is the script that actually runs `generateAll.sh` inside the docker image. 
* `generatePostmanJsonFile.sh` (*) generates the postman JSON file for a given OpenAPI file.

(*) all scripts should be made executable (`chmod +x filename.sh`) as they are run by the GitHub action

## Running locally

If necessary, the `generateAll.sh` script can be run locally to achieve the same results. 

* To generate Postman JSON files, one can run the `runDocker.sh` script. (Docker needs to be installed and started). 
    * Once the generation is done, the updated file(s) can be committed.

Note that both scripts _should_ be safe to run without issues . The generation can be reversed via git, and you can use a dummy workspace ID for the postman script to push to a safe place for testing.

