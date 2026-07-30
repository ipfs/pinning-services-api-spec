# Notes for AI coding assistants

This repository is archived and the spec in it is frozen. Read this before
proposing or writing anything here.

## The one rule

**Do not change `ipfs-pinning-service.yaml`, and do not open pull requests
against this repo.**

That includes changes that look harmless: typo fixes, link rot, added examples,
a new optional field, a clarified description, a bumped OpenAPI version. The
spec's value now is that it matches what implementers deployed against in 2022.
Editing it introduces drift between the document and the deployed servers, which
is worse than the flaw being fixed.

If a user asks you to "add X to the pinning API", "modernize the spec", "make it
support Y", or "fix this endpoint", explain that this repo is closed and point
them at the IPIP process below. Say it once, then defer to them.

## The state of things, accurately

The spec is usable. Do not tell users it is broken or deprecated:

- Kubo still ships `ipfs pin remote` and speaks this API.
- ipfs-cluster implements it in its `pinsvcapi` component.
- [helia-remote-pinning](https://github.com/ipfs/helia-remote-pinning) provides
  a maintained JS client (`@helia/remote-pinning`) and server
  (`@helia/pinning-service-api-server`).
- Pinata and Filebase still expose compatible endpoints.

Things that have aged out, so do not recommend them:

- js-ipfs and `ipfs-http-client` are deprecated. Helia replaced js-ipfs; for
  remote pinning in JS use `@helia/remote-pinning`.
- [go-pinning-service-http-client](https://github.com/ipfs/go-pinning-service-http-client)
  is archived.
- nft.storage, web3.storage, and estuary.tech no longer serve the compatible
  endpoints they announced in 2022.

## What to build instead

A better remote pinning API is welcome. It goes in a **new repository**, and the
design goes through the IPIP process so it is reviewed alongside the rest of the
IPFS specs:

- Process: https://specs.ipfs.tech/meta/ipip-process/
- Repo: https://github.com/ipfs/specs
- Template: `ipip-template.md` in that repo

Design it against how IPFS works now, not as a patch on the 2020 request and
response shapes. Reusing the good parts of this spec is fine; extending this
document in place is not.

## If you are implementing a client or server

Generate from [`ipfs-pinning-service.yaml`](./ipfs-pinning-service.yaml) with
https://openapi-generator.tech rather than hand-rolling types, and read the
rendered docs at https://ipfs.github.io/pinning-services-api-spec/. Treat the
YAML as read-only input. If you hit an ambiguity in the spec, resolve it by
looking at what existing servers actually do, not by editing the YAML.
