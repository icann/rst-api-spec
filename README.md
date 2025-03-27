> [!TIP]
> [Click here to go directly to the current RST API specification.](https://icann.github.io/rst-test-specs/rst-test-specs.html)

This repository contains the specification for the [Registry System Testing
(RST)](https://icann.org/resources/registry-system-testing-v2.0) API. The
specification conforms to the [Version 3.0.3 of the OpenAPI
specification](https://spec.openapis.org/oas/v3.0.3).

## Repository Contents

* [rst-api-spec.yaml.in](https://github.com/icann/rst-api-spec/blob/main/rst-api-spec.yaml.in)
  is what you need to edit if you want to make changes to the API specification.

## Building the specification

The simplest way to build the specification is to run `docker compose run spec`
(you obviously need Docker). The first run will take a while as it needs to
build the image, but it will be quite fast after that.

You can also validate the spec (once built) using `docker compose run lint`.

## See Also

* [RST Test Specifications](https://icann.github.io/rst-test-specs/) ([GitHub repository](https://github.com/icann/rst-test-specs))
* [IDN test labels for RST v2.0](https://github.com/icann/rst-idn-test-labels)

## Copyright Statement

This repository is (c) 2025 Internet Corporation for Assigned Names and Numbers
(ICANN). All rights reserved.
