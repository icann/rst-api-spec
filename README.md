This repository contains the specification for the Registry System Testing (RST)
API. The specification conforms to the [Version 3.1.0 of the OpenAPI
specification](https://spec.openapis.org/oas/latest.html).

## Repository Contents

* [rst-api-spec.yaml.in](https://github.com/icann/rst-api-spec/blob/main/rst-api-spec.yaml.in)
  is what you need to edit if you want to make changes to the API specification.

## Building the specification

The simplest way to build the specification is to run `docker compose up spec`
(you obviously need Docker). The first run will take a while as it needs to
build the image, but it will be quite fast after that.

You can also validate the spec (once built) using `docker compose up lint`.

## Branches

All development is done on the `dev` branch. The `main` branch is updated every
 Wednesday from the `dev` branch.

## See Also

* [RST Test Specifications](https://icann.github.io/rst-test-specs/) ([GitHub repository](https://github.com/icann/rst-test-specs))

## Copyright Statement

This repository is (c) 2024 Internet Corporation for Assigned Names and Numbers
(ICANN). All rights reserved.
