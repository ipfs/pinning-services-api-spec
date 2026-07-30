> [!IMPORTANT]
> **This repository is archived. The spec is frozen and will not change.**
>
> Use it as-is: [`ipfs-pinning-service.yaml`](./ipfs-pinning-service.yaml) is
> unchanged since 2022, several services still speak it, and Kubo still ships a
> client for it. But work on it has stopped and should not be resumed here.
> The API has ossified past the point where a revision is worth the effort.
> If you want a better remote pinning API, design it fresh and propose it as an
> [IPIP](https://specs.ipfs.tech/meta/ipip-process/) in
> [ipfs/specs](https://github.com/ipfs/specs). See
> [Why this is frozen](#why-this-is-frozen).

# Pinning Service API Spec

[![](https://img.shields.io/badge/made%20by-Protocol%20Labs-blue.svg?style=flat-square)](https://protocol.ai)
[![](https://img.shields.io/badge/project-IPFS-blue.svg?style=flat-square)](https://ipfs.tech/)
[![](https://img.shields.io/badge/status-permanent-blue.svg?style=flat-square)](https://github.com/ipfs/specs/#understanding-the-meaning-of-the-spec-badges-and-their-lifecycle)

> This repository contains the specs for the vendor-agnostic pinning service API for the IPFS ecosystem

[![pinning-services-api-contex.png](https://user-images.githubusercontent.com/157609/108572745-438fc300-7313-11eb-93c3-c8b29c0da988.png)](#about)

- [About](#about)
- [Why this is frozen](#why-this-is-frozen)
- [Specification](#specification)
  - [Code generation](#code-generation) (client/server)
- [Adoption](#adoption)
  - [Client libraries](#client-libraries)
  - [Server implementations](#server-implementations)
  - [Online services](#online-services)
- [Contribute](#contribute)

## About

A **pinning service** is a service that accepts [CIDs](https://github.com/multiformats/cid) from a user in order to host the data associated with them.

The rationale behind defining a generic pinning service API is to have a baseline functionality and interface that can be provided by pinning services, so that tools can be built on top of a common base of functionality.

In [this presentation](https://youtu.be/Pcv8Bt4HMVU), IPFS creator Juan Benet discusses current and potential pinning use cases, and how a standardized IPFS pinning API can meet these envisioned needs.

## Why this is frozen

The spec reached v1.0.0 in 2020 and stopped changing in 2022. What is here works
and is still deployed, so nothing is being taken away. What is not going to
happen is further development, in this repo or anywhere else under this name.

The reasons are worth stating plainly, so nobody spends months rediscovering them:

- **The API is ossified.** Deployed servers, generated clients, and third-party
  integrations all pinned themselves to the 2020 shape of the requests and
  responses. Any change worth making is a breaking change, and a breaking change
  to a spec with this much deployed surface is a new spec wearing an old name.
- **The tooling around it aged out.** js-ipfs and `ipfs-http-client` are
  deprecated in favour of [Helia](https://github.com/ipfs/helia), and
  [go-pinning-service-http-client](https://github.com/ipfs/go-pinning-service-http-client)
  is archived. Some implementations are still maintained, but the set of things
  that would have to move together for a v2 no longer moves together.
- **The problem moved.** The design assumes a client that hands CIDs to a server
  and polls for status. Newer work on providing, retrieval, and verifiable
  transfer sits elsewhere, and a modern remote pinning API should be designed
  against that, not retrofitted onto this.

**If you want to build a better API, do it.** Start a new repository, and take
the design through the [IPIP process](https://specs.ipfs.tech/meta/ipip-process/)
in [ipfs/specs](https://github.com/ipfs/specs) so it gets reviewed alongside the
rest of the IPFS specifications. Please do not open pull requests here.

## Specification

This API is defined as an OpenAPI spec in YAML format:

* **[ipfs-pinning-service.yaml](./ipfs-pinning-service.yaml)** ![](https://img.shields.io/badge/status-permanent-blue.svg?style=flat-square)

### Documentation

You can find human-readable API documentation generated from the YAML file here:

- **[https://ipfs.github.io/pinning-services-api-spec](https://ipfs.github.io/pinning-services-api-spec/)**

### Code generation

https://openapi-generator.tech allows generation of API client libraries (SDK generation), server stubs, documentation and configuration automatically, given the OpenAPI spec at [ipfs-pinning-service.yaml](./ipfs-pinning-service.yaml).

Give it a try before you resort to implementing things from scratch.

## Adoption

The lists below record what implemented this API. They are a snapshot, not a
maintained directory, and some entries have since been archived or shut down.

Support in IPFS tooling:

- [Kubo](https://github.com/ipfs/kubo) (since [v0.8.0](https://github.com/ipfs/kubo/releases/v0.8.0): `ipfs pin remote --help`, see how to [work with remote pinning services](https://docs.ipfs.tech/how-to/work-with-pinning-services/))
- [ipfs-cluster](https://ipfscluster.io) (`pinsvcapi` component)
- [ipfs-webui](https://github.com/ipfs/ipfs-webui) (remote pin support since [v2.12.0](https://github.com/ipfs/ipfs-webui/releases/v2.12.0))
- [ipfs-desktop](https://github.com/ipfs/ipfs-desktop) (>0.20.x)
- [js-ipfs](https://github.com/ipfs/js-ipfs#readme) and [ipfs-http-client](https://www.npmjs.com/package/ipfs-http-client) shipped `ipfs.pin.remote.*` APIs. Both are deprecated; [Helia](https://github.com/ipfs/helia) replaced js-ipfs, and remote pinning for Helia lives in [helia-remote-pinning](https://github.com/ipfs/helia-remote-pinning).

### Client libraries

- [@helia/remote-pinning](https://github.com/ipfs/helia-remote-pinning/tree/main/packages/client)
  Remote pinning for [Helia](https://github.com/ipfs/helia). This is the maintained JS client.
- [@ipfs-shipyard/pinning-service-client](https://github.com/ipfs-shipyard/js-pinning-service-http-client/)
  Generated JS client, used in the [compliance test suite](https://github.com/ipfs/pinning-services-api-spec/issues/64).
- [go-pinning-service-http-client](https://github.com/ipfs/go-pinning-service-http-client) (archived)
  Go client, vendored into Kubo for `ipfs pin remote` commands.
- https://openapi-generator.tech/docs/generators#client-generators
  Use the [YAML file](./ipfs-pinning-service.yaml) to generate a client for your language.
- [auspinner](https://github.com/2color/auspinner)
  A stateless CLI tool to pin and serve CAR files to IPFS pinning services using HTTP and Bitswap.

### Server implementations

- [@helia/pinning-service-api-server](https://github.com/ipfs/helia-remote-pinning/tree/main/packages/server)
  Server implementation powered by Helia.
- [ipfs-cluster](https://github.com/ipfs-cluster/ipfs-cluster)
  Pinset orchestration for IPFS. Exposes this API through its `pinsvcapi` component.
- [js-mock-ipfs-pinning-service](https://github.com/ipfs-shipyard/js-mock-ipfs-pinning-service)
  In-memory service for testing purposes.
- [rb-pinning-service-api](https://github.com/ipfs-shipyard/rb-pinning-service-api)
  A Rails app that implements the IPFS Pinning Service API.
- https://openapi-generator.tech/docs/generators#server-generators
  Use the [YAML file](./ipfs-pinning-service.yaml) to generate server boilerplate for your language.

### CI/CD

- https://github.com/marketplace/actions/ipfs-remote-pinning
  IPFS Pinning GitHub Action that adds data to IPFS and pins it to any `ENDPOINT` compatible with Pinning Service API

### Online services

Services that exposed a compatible endpoint. Check with the provider before
relying on any of these; this list is no longer being updated.

- https://pinata.cloud ([documentation](https://docs.pinata.cloud/api-reference/pinning-service-api))
  - `ipfs pin remote service add pinata https://api.pinata.cloud/psa YOUR_JWT`
- https://filebase.com ([documentation](https://filebase.com/docs/ipfs/pinning-service-api))
  - `ipfs pin remote service add filebase https://api.filebase.io/v1/ipfs SECRET-ACCESS-TOKEN`
- nft.storage, web3.storage, and estuary.tech offered compatible endpoints in
  2022. Those endpoints are gone.

### Timeline

- 2022 Q3
  - IPFS Pin Sync is announced by Filebase
  - Last substantive change to the spec
- 2022 Q1
  - web3.storage API support
  - estuary.tech API support
  - Mock server for local development: https://github.com/ipfs-shipyard/js-mock-ipfs-pinning-service
  - WIP official API client for JS: https://github.com/ipfs-shipyard/js-pinning-service-http-client/
  - WIP compliance test suite: https://github.com/ipfs/pinning-services-api-spec/issues/64
  - ipfs-cluster support ([commit](https://github.com/ipfs-cluster/ipfs-cluster/commit/9549e0c86e500a0b15020f6e5d48664d1f3ab37d))
- 2021 Q1
  - [go-ipfs 0.8.0](https://github.com/ipfs/kubo/releases/v0.8.0) shipped with built-in client for v1.0.0 of this API
  - Pinata announces endpoint compatible with this spec
  - ipfs-webui [v2.12.0](https://github.com/ipfs/ipfs-webui/releases/v2.12.0) provides UI based on `pin remote` commands
  - Textile is working on Bucket Pinning API
- 2020 Q3
  - IPFS GUI WG working on adding support for pinning services into IPFS Desktop/Web UI:
    - [Epic: Pinning service integration · Issue #91 · ipfs/ipfs-gui](https://github.com/ipfs/ipfs-gui/issues/91)
    - [Analysis of remote pinning services vs the needs of IPFS Web UI](https://docs.google.com/document/d/1f0R7woLtW_YTv9P9IOrUNK6QafgctJ7qTggEUdepD_c/)
  - [ipfs/pinning-services-api-specs](https://github.com/ipfs/pinning-services-api-spec) is created as a place for stakeholders to collaborate and finalize the API
    - 2020-07-14: Spec in draft status is ready for implementation
    - 2020-08: Addressing feedback from early implementers
    - 2020-09: End-to-end testing
- 2020 Q2
  - Pinning Summit 2020 ([recorded talks](https://www.youtube.com/watch?v=rYD2lfuatJM&list=PLuhRWgmPaHtTvsxuZ9T-tMlu_v0lja6v5))
- 2019 Q2
  - Creation of a generic pinning service API proposed in [ipfs/notes/issues/378](https://github.com/ipfs/notes/issues/378)

## Contribute

This repository is archived and is not accepting contributions. Nothing here is
going to be revised, including typo fixes and link rot, because publishing a new
version of a frozen spec is worse than leaving it exactly where implementers
found it.

To propose a new or better remote pinning API, open an
[IPIP](https://specs.ipfs.tech/meta/ipip-process/) in
[ipfs/specs](https://github.com/ipfs/specs) and build it in a new repository.

The IPFS [Code of Conduct](https://github.com/ipfs/community/blob/master/code-of-conduct.md) applies there as it did here.

### Spec lifecycle

The label system used to identify the state of aspects of this spec:

- ![](https://img.shields.io/badge/status-wip-orange.svg?style=flat-square) — A work-in-progress, possibly to describe an idea before actually committing to a full draft of the spec
- ![](https://img.shields.io/badge/status-draft-yellow.svg?style=flat-square) — A draft that is ready to review, and should be implementable
- ![](https://img.shields.io/badge/status-reliable-green.svg?style=flat-square) — A spec that has been adopted (implemented) and can be used as a reference to learn how the system works
- ![](https://img.shields.io/badge/status-stable-brightgreen.svg?style=flat-square) — We consider this spec to close to final; it might be improved, but the system it specifies should not fundamentally change
- ![](https://img.shields.io/badge/status-permanent-blue.svg?style=flat-square) — This spec will not change
- ![](https://img.shields.io/badge/status-deprecated-red.svg?style=flat-square) — This spec is no longer in use

This spec is **permanent**.

If you are an AI coding assistant working in this repo, read [AGENTS.md](AGENTS.md) first.
