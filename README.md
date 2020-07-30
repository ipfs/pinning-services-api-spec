# Pinning Service API Spec

[![](https://img.shields.io/badge/made%20by-Protocol%20Labs-blue.svg?style=flat-square)](http://protocol.ai)
[![](https://img.shields.io/badge/project-IPFS-blue.svg?style=flat-square)](https://ipfs.io/)
[![](https://github.com/ipfs/pinning-services-api-spec/workflows/Lint/badge.svg?branch=master)](https://github.com/ipfs/pinning-services-api-spec/actions?query=workflow%3ALint+branch%3Amaster)
[![](https://img.shields.io/badge/status-draft-yellow.svg?style=flat-square)](https://github.com/ipfs/specs/#understanding-the-meaning-of-the-spec-badges-and-their-lifecycle)

> This repository contains the specs for the vendor-agnostic pinning service API for the IPFS ecosystem

![pinning-services-api-contex.png](https://bafkreibw7a6pq7zq4ljtpwdegzr5bru653q6uevzvq65pq6pqrjorxpkli.ipfs.dweb.link/?filename=pinning-services-api-contex.png)

- [About](#about)
- [Specification](#specification)
- [Adoption](#adoption)
- [Contribute](#contribute)

## About

A Pinning Service is a service that accepts [CIDs](https://github.com/ipld/cid/) from a user and will host the data associated with them.

The rationale behind defining a generic pinning service API is to have a baseline functionality and interface that can be provided by these services so that tools can be built on top of a common base of functionality. 

In [this presentation](https://youtu.be/Pcv8Bt4HMVU), IPFS creator Juan Benet discusses current and potential pinning use cases and how a standardized IPFS Pinning API could meet these envisioned needs. 

The API spec in this repo is the first step towards that future.

## Specification 

API is defined as OpenAPI spec in YAML format:

* **[ipfs-pinning-service.yaml](./ipfs-pinning-service.yaml)**


### Documentation

API documentation generated from the YAML file can be found at:

- **[https://ipfs.github.io/pinning-services-api-spec](https://ipfs.github.io/pinning-services-api-spec/)**

## Adoption

We are working with pinning services to expose this API, stay tunned  ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square)
  - `{this could be your project}`

Built-in support for pinning services exposing this API is coming to IPFS tooling in Q3: 
  - [go-ipfs](https://github.com/ipfs/go-ipfs) / [js-ipfs](https://github.com/ipfs/js-ipfs) (CLI/HTTP API)  ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square)
  - [ipfs-desktop](https://github.com/ipfs-shipyard/ipfs-desktop) / [ipfs-webui](https://github.com/ipfs-shipyard/ipfs-webui) (GUIs) ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square)


### Timeline

- 2019 Q2 
  - Creation of a generic Pinning Service API proposed in [ipfs/notes/issues/378](https://github.com/ipfs/notes/issues/378)
- 2020 Q2
  - Pinning Summit 2020 ([website](https://ipfspinningsummit.com/), [recorded talks](https://www.youtube.com/watch?v=rYD2lfuatJM&list=PLuhRWgmPaHtTvsxuZ9T-tMlu_v0lja6v5))
- 2020 Q3
  - IPFS GUI Team looking into adding support for Pinning Services into Desktop apps
    - [Epic: Pinning service integration · Issue #91 · ipfs/ipfs-gui](https://github.com/ipfs/ipfs-gui/issues/91)
    - [Analysis of Remote Pinning Services vs the needs of IPFS WebUI](https://docs.google.com/document/d/1f0R7woLtW_YTv9P9IOrUNK6QafgctJ7qTggEUdepD_c/)
  - [ipfs/pinning-services-api-specs](https://github.com/ipfs/pinning-services-api-specs) is created as a place for stakeholders to collaborate and finalize the API
    - 2020-07-14: spec in draft status is ready for implementation


## Contribute

Suggestions, contributions, criticisms are welcome. Though please make sure to familiarize yourself deeply with IPFS, the models it adopts, and the principles it follows.
This repository falls under the IPFS [Code of Conduct](https://github.com/ipfs/community/blob/master/code-of-conduct.md).

### Spec lifecycle

We use the following label system to identify the state of this spec:

- ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square) - A work-in-progress, possibly to describe an idea before actually committing to a full draft of the spec.
- ![](https://img.shields.io/badge/status-draft-yellow.svg?style=flat-square) - A draft that is ready to review. It should be implementable.
- ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square) - A spec that has been adopted (implemented) and can be used as a reference point to learn how the system works.
- ![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square) - We consider this spec to close to final, it might be improved but the system it specifies should not change fundamentally.
- ![](https://img.shields.io/badge/status-permanent-blue.svg?style=flat-square) - This spec will not change.
- ![](https://img.shields.io/badge/status-deprecated-red.svg?style=flat-square) - This spec is no longer in use.
