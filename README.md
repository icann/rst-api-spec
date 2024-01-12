# ICANN Registry System Testing (RST) API Specification

This repository contain the specification for the Registry System Testing (RST)
API.

The specification is written in YAML and conforms to the [OpenApi
3.1.0](https://spec.openapis.org/oas/latest.html) specification.

A user-friendly rendering of the API specification is [here](rst-ap-spec.html),
which is generated using the [Swagger Editor](https://editor-next.swagger.io).

There are actually *two* different YAML files, representing two different
"views" of the API:

1. [rst-api-spec.yaml](https://icann.github.io/rst-api-spec/rst-api-spec.html)
   represents the external view of the API, and is limited just to those
   endpoints that external users (RSPs and registry operators) need to access;

2. [rst-api-spec-internal.yaml](https://icann.github.io/rst-api-spec/rst-api-spec-internal.html)
   represents ICANN org's view of the API, and includes operations required by
   internal ICANN systems and the test orchestrator which actually runs the
   tests. External users (RSPs and registry operators) won't have access to
   these endpoints (except in OT&E, where some of them *are* available).

Each of these files are generated from
[rst-api-spec.yaml.in](rst-api-spec.yaml.in), which is the master file which
includes details of both views, and which is therefore useful for actually
*implementing* the API. To generate the two views, run `make` *(you will need
[gpp](https://files.nothingisreal.com/software/gpp/gpp.html))*.

You may also be interested in the following:

* [a high-level workflow of the RST system](https://icann.github.io/rst-api-spec/etc/workflow.svg) ([source](etc/workflow.mmd))
* [a state diagram for test request objects](test-object-state-machine.svg) ([source](etc/test-object-state-machine.mmd))

## Copyright Statement

This repository is (c) 2024 Internet Corporation for Assigned Names and Numbers
(ICANN). All rights reserved.
