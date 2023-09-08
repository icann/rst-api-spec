# ICANN Registry System Testing (RST) API specification

This repository contain the proposed specification for the Registry System Testing (RST) API.
The specification is written in YAML and conforms to the [OpenApi 3.1.0](https://spec.openapis.org/oas/latest.html) specification.

## Overview

ICANN operates a [Registry System Testing](https://www.icann.org/resources/registry-system-testing) (RST) system for generic TLDs.
The system is invoked for the following events:

1. prior to the delegation of a new TLD ("pre-delegation testing" or PDT)
2. prior to approval of a change of [Material Subcontracting Arrangement](https://www.icann.org/resources/material-subcontracting-arrangement) ("MSA") - such as a change to a Registry Service Provider or DNS service provider
3. prior to approval of new registry services requested through the [Registry Services Evaluation Policy](https://www.icann.org/rsep-en)

## History

The original pre-delegation testing system was built by IIS (the ccTLD operator of .se) under a subcontracting arrangement with ICANN.
Many of the tools were based on, or published as, open source software.

ICANN brought this system in-house in 20XX.

## Problem Statement

Currently the RST system is highly manual and there is no automated orchestration of test processes or centralised storage of data (test inputs, results, log data, etc).
This means that it will be hard to scale the system during the next gTLD round, where it is assumed up to 2,000 gTLDs will be applied for.

## Design goals

### Mandatory

1. Automate (to the fullest extent possible) the RST process, to reduce the manual work required to perform tests.
2. Provide an API that allows internal systems (such as the RSP evaluation system) to request an Registry System Test.

### Desirable

1. Provide a way for ROs and RSPs to request tests, so they can build them into their CI/CD processes.

