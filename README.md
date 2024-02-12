This repository contain the specification for the Registry System Testing (RST)
API.

The specification is written in YAML and conforms to the [Version 3.1.0 of the
OpenAPI specification](https://spec.openapis.org/oas/latest.html):

## API specification

* [RST-API Specification](https://icann.github.io/rst-api-spec/rst-api-spec.html) ([YAML](rst-api-spec.yaml))

This represents a view of the API suitable for RSPs and Registry Operators
(i.e., those who are undergoing registry system testing).

### Internal ICANN view

* [RST-API Specification (internal view)](https://icann.github.io/rst-api-spec/rst-api-spec-internal.html) ([YAML](rst-api-spec-internal.yaml))

This represents ICANN org's view of the API, and includes operations required by
internal ICANN systems and the test orchestrator which actually runs the tests.
External users (RSPs and registry operators) won't have access to these
endpoints (except in OT&E, where some of them *are* available).

## Repository Contents

* [rst-api-spec.yaml.in](https://github.com/icann/rst-api-spec/blob/main/rst-api-spec.yaml.in)
  is what you need to edit if you want to make changes to the API.

* [Makefile](Makefile) provides a way to generate the build artifacts. It uses
  [gpp](https://logological.org/gpp) to create the YAML file, [mermaid-cli](https://github.com/mermaid-js/mermaid-cli)
  to convert the Mermaid files into diagrams, and a Perl script to import input
  parameter schemas from the [test specs](https://github.com/icann/rst-test-specs).

* If you don't want to install all the dependencies, but have
  [Docker](https://docker.com) installed, you can use `docker compose up spec`
  to build the YAML files.

## Branches

All development is done on the `dev` branch. The `main` branch is updated every
 Wednesday from the `dev` branch.

## See Also

* [RST Test Specifications](https://icann.github.io/rst-test-specs/) ([GitHub repository](https://github.com/icann/rst-test-specs))

## Copyright Statement

This repository is (c) 2024 Internet Corporation for Assigned Names and Numbers
(ICANN). All rights reserved.
