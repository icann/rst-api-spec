> [!TIP]
> [Click here to go directly to the current RST API specification.](https://icann.github.io/rst-api-spec/rst-api-spec.html)

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

## Releasing a new version

1. Make the changes you want to make.
2. Once committed, tag the commit. The tag should take the form `vYYYY.DD` where
   `YYYY` is the current year and `DD` is a two-digest serial number that resets
   to `01` at the start of each year. Then push the tag to GitHub using `git
   push --tags.
3. Create a new [release](https://github.com/icann/rst-api-spec/releases/new)
   using the tag.

Since the API spec includes data elements from the [RST test
specs](https://github.com/icann/rst-test-specs), each time there is a release of
the test specs, a new version of the API spec must be released, in order to
incorporate any changes to those data elements.

## See Also

* [RST Test Specifications](https://icann.github.io/rst-test-specs/) ([GitHub repository](https://github.com/icann/rst-test-specs))
* [IDN test labels for RST v2.0](https://github.com/icann/rst-idn-test-labels)

## Copyright Statement

This repository is (c) 2025 Internet Corporation for Assigned Names and Numbers
(ICANN). All rights reserved.
