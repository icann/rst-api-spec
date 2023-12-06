# ICANN Registry System Testing (RST) API specification

This repository contain the specification for the Registry System Testing (RST) API.

The specification is written in YAML and conforms to the [OpenApi 3.1.0](https://spec.openapis.org/oas/latest.html) specification.

There are actually *two* different YAML files:

* [rst-api-spec.yaml](https://icann.github.io/rst-api-spec/index.html)
  represents a test subject's view of the API, and is limited just to those
  endpoints they need to use;
* [rst-api-spec-internal.yaml](https://icann.github.io/rst-api-spec/rst-api-spec-internal.html)
  represents ICANN org's view of the API, and includes operations required by
  internal ICANN systems and the test orchestrator which actually runs the
  tests.

Each of these files are generated from
[rst-api-spec.yaml.in](rst-api-spec.yaml.in), which is the master file which
includes details of both views, and which is therefore useful for actually
*implementing* the API. To generate the two views, run `make` *(you will need
[gpp](https://files.nothingisreal.com/software/gpp/gpp.html))*.
