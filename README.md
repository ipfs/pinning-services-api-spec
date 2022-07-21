# Pinning Service API Spec

[![](https://img.shields.io/badge/made%20by-Protocol%20Labs-blue.svg?style=flat-square)](http://protocol.ai)
[![](https://img.shields.io/badge/project-IPFS-blue.svg?style=flat-square)](https://ipfs.io/)
[![](https://github.com/ipfs/pinning-services-api-spec/workflows/Lint/badge.svg?branch=main)](https://github.com/ipfs/pinning-services-api-spec/actions?query=workflow%3ALint+branch%3Amain)
[![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square)](https://github.com/ipfs/specs/#understanding-the-meaning-of-the-spec-badges-and-their-lifecycle)

> This repository contains the specs for the vendor-agnostic pinning service API for the IPFS ecosystem

[![pinning-services-api-contex.png](https://user-images.githubusercontent.com/157609/108572745-438fc300-7313-11eb-93c3-c8b29c0da988.png)](#about)

- [About](#about)
- [Specification](#specification)
  - [Code generation](#code-generation) (client/server)
- [Adoption](#adoption)
  - [Client libraries](#client-libraries)
  - [Server implementations](#server-implementations)
  - [Online services](#online-services)
- [Contribute](#contribute)

## About

A **pinning service** is a service that accepts [CIDs](https://github.com/ipld/cid/) from a user in order to host the data associated with them.

The rationale behind defining a generic pinning service API is to have a baseline functionality and interface that can be provided by pinning services, so that tools can be built on top of a common base of functionality. 

In [this presentation](https://youtu.be/Pcv8Bt4HMVU), IPFS creator Juan Benet discusses current and potential pinning use cases, and how a standardized IPFS pinning API can meet these envisioned needs. 

The API spec in this repo is the first step towards that future.

## Specification 

This API is defined as an OpenAPI spec in YAML format:

* **[ipfs-pinning-service.yaml](./ipfs-pinning-service.yaml)** ![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square)


### Documentation

You can find human-readable API documentation generated from the YAML file here:

- **[https://ipfs.github.io/pinning-services-api-spec](https://ipfs.github.io/pinning-services-api-spec/)** ![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square)

### Code generation

https://openapi-generator.tech allows generation of API client libraries (SDK generation), server stubs, documentation and configuration automatically, given the OpenAPI spec at [ipfs-pinning-service.yaml](./ipfs-pinning-service.yaml).

Give it a try before you resort to implementing things from scratch.

## Adoption

Built-in support for pinning services exposing this API is coming to IPFS tooling: 
  - [go-ipfs](https://github.com/ipfs/go-ipfs)  ![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square) (since [v0.8.0](https://github.com/ipfs/go-ipfs/releases/v0.8.0): `ipfs pin remote --help`, see how to [work with remote pinning services](https://docs.ipfs.io/how-to/work-with-pinning-services/))
  - [js-ipfs-http-client](https://www.npmjs.com/package/ipfs-http-client) ![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square) (`ipfs.pin.remote.*` JS APIs)
  - [ipfs-cluster](https://cluster.ipfs.io) ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square) ([issue](https://github.com/ipfs/ipfs-cluster/issues/1213))
  - [js-ipfs](https://github.com/ipfs/js-ipfs#readme) – ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square) ([js-ipfs/pull/3588](https://github.com/ipfs/js-ipfs/pull/3588))
  - [ipfs-webui](https://github.com/ipfs-shipyard/ipfs-webui) ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square)  (remote pin support since [v2.12.0](https://github.com/ipfs/ipfs-webui/releases/v2.12.0))
  - [ipfs-desktop](https://github.com/ipfs-shipyard/ipfs-desktop) ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square) (>0.20.x)

### Client libraries
- [js-pinning-service-http-client](https://github.com/ipfs-shipyard/js-pinning-service-http-client/)  ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square)  
  An IPFS Pinning Service HTTP Client library for JS, used in [compliance test suite](https://github.com/ipfs/pinning-services-api-spec/issues/64).
- [go-pinning-service-http-client](https://github.com/ipfs/go-pinning-service-http-client)  ![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square)  
  An IPFS Pinning Service HTTP Client library for Go, used by go-ipfs internally in `ipfs pin remote --help` commands.
- https://openapi-generator.tech/docs/generators#client-generators ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square)  
  Use [YAML file](./ipfs-pinning-service.yaml) to generate client for your language  

### Server implementations
- https://github.com/ipfs/ipfs-cluster ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square)
   Pinset orchestration for IPFS  – [tracking issue](https://github.com/ipfs/ipfs-cluster/issues/1213)
- https://github.com/ipfs-shipyard/js-mock-ipfs-pinning-service ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square)  
  Implementation of in-memory service for testing purposes
- https://github.com/ipfs-shipyard/rb-pinning-service-api ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square)  
  A Rails app that implements the IPFS Pinning Service API
- https://openapi-generator.tech/docs/generators#server-generators ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square)  
  Use [YAML file](./ipfs-pinning-service.yaml) to generate server boilerplate for your language

### CI/CD

- https://github.com/marketplace/actions/ipfs-remote-pinning  
  IPFS Pinning GitHub Action that adds data to IPFS and pins it to any `ENDPOINT` compatible with Pinning Service API

### Online services

- https://pinata.cloud – ([documentation](https://pinata.cloud/documentation#PinningServicesAPI))
  - `ipfs pin remote service add pinata https://api.pinata.cloud/psa YOUR_JWT`
- https://estuary.tech – ([documentation](https://docs.estuary.tech/pinning-list))
  - `ipfs pin remote service add estuary https://api.estuary.tech/pinning/ YOUR_API_KEY`
- https://web3.storage – ([documentation](https://docs.web3.storage/how-tos/pinning-services-api))
  - `ipfs pin remote service add web3-storage https://api.web3.storage/ YOUR_API_KEY`
- https://nft.storage
  - `ipfs pin remote service add nft-storage https://nft.storage/api YOUR_API_KEY`
- https://filebase.com - ([documentation](https://docs.filebase.com/storage-networks/ipfs/ipfs-pinning#how-to-re-pin-existing-ipfs-cids-with-filebase))
  - `ipfs pin remote service add filebase https://api.filebase.com/v1/ipfs "ACCESS-KEY:SECRET-KEY:BUCKET-NAME"` 
- `{your project could be here}` – open a PR!

### Timeline

- 2022 Q1
  - [web3.storage](https://web3.storage) API support: https://docs.web3.storage/how-tos/pinning-services-api
  - [estuary.tech](https://estuary.tech) API support: https://docs.estuary.tech/pinning-list
  - Mock server for local development: https://github.com/ipfs-shipyard/js-mock-ipfs-pinning-service
  - WIP official API client for JS: https://github.com/ipfs-shipyard/js-pinning-service-http-client/
  - WIP compliance test suite: https://github.com/ipfs/pinning-services-api-spec/issues/64
  - WIP ipfs-cluster support ([commit](https://github.com/ipfs/ipfs-cluster/commit/9549e0c86e500a0b15020f6e5d48664d1f3ab37d))
- 2021 Q1
  - [go-ipfs 0.8.0](https://github.com/ipfs/go-ipfs/releases/v0.8.0) shipped with built-in client for v1.0.0 of this API
  - Pinata announces endpoint compatible with this spec: https://pinata.cloud/documentation#PinningServicesAPI
  - ipfs-webui [v2.12.0](https://github.com/ipfs/ipfs-webui/releases/v2.12.0) provides UI based on `pin remote` commands
  - Textile is [working on Bucket Pinning API](https://github.com/textileio/textile/discussions/499)
- 2020 Q3
  - IPFS GUI WG working on adding support for pinning services into IPFS Desktop/Web UI:
    - [Epic: Pinning service integration · Issue #91 · ipfs/ipfs-gui](https://github.com/ipfs/ipfs-gui/issues/91)
    - [Analysis of remote pinning services vs the needs of IPFS Web UI](https://docs.google.com/document/d/1f0R7woLtW_YTv9P9IOrUNK6QafgctJ7qTggEUdepD_c/)
  - [ipfs/pinning-services-api-specs](https://github.com/ipfs/pinning-services-api-specs) is created as a place for stakeholders to collaborate and finalize the API
    - 2020-07-14: Spec in draft status is ready for implementation
    - 2020-08: Addressing feedback from early implementers
    - 2020-09: End-to-end testing
- 2020 Q2
  - Pinning Summit 2020 ([website](https://ipfspinningsummit.com/), [recorded talks](https://www.youtube.com/watch?v=rYD2lfuatJM&list=PLuhRWgmPaHtTvsxuZ9T-tMlu_v0lja6v5))
- 2019 Q2 
  - Creation of a generic pinning service API proposed in [ipfs/notes/issues/378](https://github.com/ipfs/notes/issues/378)

## Contribute

Suggestions, contributions, and criticisms are welcome! However, please make sure to familiarize yourself deeply with IPFS, the models it adopts, and the principles it follows.

This repository falls under the IPFS [Code of Conduct](https://github.com/ipfs/community/blob/master/code-of-conduct.md).

### Spec lifecycle

We use the following label system to identify the state of aspects of this spec:

- ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square) — A work-in-progress, possibly to describe an idea before actually committing to a full draft of the spec
- ![](https://img.shields.io/badge/status-draft-yellow.svg?style=flat-square) — A draft that is ready to review, and should be implementable
- ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square) — A spec that has been adopted (implemented) and can be used as a reference to learn how the system works
- ![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square) — We consider this spec to close to final; it might be improved, but the system it specifies should not fundamentally change
- ![](https://img.shields.io/badge/status-permanent-blue.svg?style=flat-square) — This spec will not change
- ![](https://img.shields.io/badge/status-deprecated-red.svg?style=flat-square) — This spec is no longer in use
