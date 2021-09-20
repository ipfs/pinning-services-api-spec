
3.0.3±H
IPFS Pinning Service APIÉG

## About this spec
The IPFS Pinning Service API is intended to be an implementation-agnostic API&#x3a;
- For use and implementation by pinning service providers
- For use in client mode by IPFS nodes and GUI-based applications

### Document scope and intended audience
The intended audience of this document is **IPFS developers** building pinning service clients or servers compatible with this OpenAPI spec. Your input and feedback are welcome and valuable as we develop this API spec. Please join the design discussion at [github.com/ipfs/pinning-services-api-spec](https://github.com/ipfs/pinning-services-api-spec).

**IPFS users** should see the tutorial at [docs.ipfs.io/how-to/work-with-pinning-services](https://docs.ipfs.io/how-to/work-with-pinning-services/) instead.

### Related resources
The latest version of this spec and additional resources can be found at:
- Specification: https://github.com/ipfs/pinning-services-api-spec/raw/main/ipfs-pinning-service.yaml
- Docs: https://ipfs.github.io/pinning-services-api-spec/
- Clients and services: https://github.com/ipfs/pinning-services-api-spec#adoption

# Schemas
This section describes the most important object types and conventions.

A full list of fields and schemas can be found in the `schemas` section of the [YAML file](https://github.com/ipfs/pinning-services-api-spec/blob/master/ipfs-pinning-service.yaml).

## Identifiers
### cid
[Content Identifier (CID)](https://docs.ipfs.io/concepts/content-addressing/) points at the root of a DAG that is pinned recursively.
### requestid
Unique identifier of a pin request.

When a pin is created, the service responds with unique `requestid` that can be later used for pin removal. When the same `cid` is pinned again, a different `requestid` is returned to differentiate between those pin requests.

Service implementation should use UUID, `hash(accessToken,Pin,PinStatus.created)`, or any other opaque identifier that provides equally strong protection against race conditions.

## Objects
### Pin object

![pin object](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/pin.png)

The `Pin` object is a representation of a pin request.

It includes the `cid` of data to be pinned, as well as optional metadata in `name`, `origins`, and `meta`.

### Pin status response

![pin status response object](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/pinstatus.png)

The `PinStatus` object is a representation of the current state of a pinning operation.
It includes the original `pin` object, along with the current `status` and globally unique `requestid` of the entire pinning request, which can be used for future status checks and management. Addresses in the `delegates` array are peers delegated by the pinning service for facilitating direct file transfers (more details in the provider hints section). Any additional vendor-specific information is returned in optional `info`.

# The pin lifecycle

![pinning service objects and lifecycle](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/lifecycle.png)

## Creating a new pin object
The user sends a `Pin` object to `POST /pins` and receives a `PinStatus` response:
- `requestid` in `PinStatus` is the identifier of the pin operation, which can can be used for checking status, and removing the pin in the future
- `status` in `PinStatus` indicates the current state of a pin

## Checking status of in-progress pinning
`status` (in `PinStatus`) may indicate a pending state (`queued` or `pinning`). This means the data behind `Pin.cid` was not found on the pinning service and is being fetched from the IPFS network at large, which may take time.

In this case, the user can periodically check pinning progress via `GET /pins/{requestid}` until pinning is successful, or the user decides to remove the pending pin.

## Replacing an existing pin object
The user can replace an existing pin object via `POST /pins/{requestid}`. This is a shortcut for removing a pin object identified by `requestid` and creating a new one in a single API call that protects against undesired garbage collection of blocks common to both pins. Useful when updating a pin representing a huge dataset where most of blocks did not change. The new pin object `requestid` is returned in the `PinStatus` response. The old pin object is deleted automatically.

## Removing a pin object
A pin object can be removed via `DELETE /pins/{requestid}`.


# Provider hints
A pinning service will use the DHT and other discovery methods to locate pinned content; however, it is a good practice to provide additional provider hints to speed up the discovery phase and start the transfer immediately, especially if a client has the data in their own datastore or already knows of other providers.

The most common scenario is a client putting its own IPFS node's multiaddrs in `Pin.origins`,  and then attempt to connect to every multiaddr returned by a pinning service in `PinStatus.delegates` to initiate transfer.  At the same time, a pinning service will try to connect to multiaddrs provided by the client in `Pin.origins`.

This ensures data transfer starts immediately (without waiting for provider discovery over DHT), and mutual direct dial between a client and a service works around peer routing issues in restrictive network topologies, such as NATs, firewalls, etc.

**NOTE:** Connections to multiaddrs in `origins` and `delegates` arrays should be attempted in best-effort fashion, and dial failure should not fail the pinning operation. When unable to act on explicit provider hints, DHT and other discovery methods should be used as a fallback by a pinning service.

**NOTE:** All multiaddrs MUST end with `/p2p/{peerID}` and SHOULD be fully resolved and confirmed to be dialable from the public internet. Avoid sending addresses from local networks.

# Custom metadata
Pinning services are encouraged to add support for additional features by leveraging the optional `Pin.meta` and `PinStatus.info` fields. While these attributes can be application- or vendor-specific, we encourage the community at large to leverage these attributes as a sandbox to come up with conventions that could become part of future revisions of this API.
## Pin metadata
String keys and values passed in `Pin.meta` are persisted with the pin object. This is an opt-in feature: It is OK for a client to omit or ignore these optional attributes, and doing so should not impact the basic pinning functionality.

Potential uses:
- `Pin.meta[app_id]`: Attaching a unique identifier to pins created by an app enables meta-filtering pins per app
- `Pin.meta[vendor_policy]`: Vendor-specific policy (for example: which region to use, how many copies to keep)

### Filtering based on metadata
The contents of `Pin.meta` can be used as an advanced search filter for situations where searching by `name` and `cid` is not enough.

Metadata key matching rule is `AND`:
- lookup returns pins that have `meta` with all key-value pairs matching the passed values
- pin metadata may have more keys, but only ones passed in the query are used for filtering

The wire format for the `meta` when used as a query parameter is a [URL-escaped](https://en.wikipedia.org/wiki/Percent-encoding) stringified JSON object. A lookup example for pins that have a `meta` key-value pair `{"app_id":"UUID"}` is:
- `GET /pins?meta=%7B%22app_id%22%3A%22UUID%22%7D`


## Pin status info
Additional `PinStatus.info` can be returned by pinning service.

Potential uses:
- `PinStatus.info[status_details]`: more info about the current status (queue position, percentage of transferred data, summary of where data is stored, etc); when `PinStatus.status=failed`, it could provide a reason why a pin operation failed (e.g. lack of funds, DAG too big, etc.)
- `PinStatus.info[dag_size]`: the size of pinned data, along with DAG overhead
- `PinStatus.info[raw_size]`: the size of data without DAG overhead (eg. unixfs)
- `PinStatus.info[pinned_until]`: if vendor supports time-bound pins, this could indicate when the pin will expire

# Pagination and filtering
Pin objects can be listed by executing `GET /pins` with optional parameters:

- When no filters are provided, the endpoint will return a small batch of the 10 most recently created items, from the latest to the oldest.
- The number of returned items can be adjusted with the `limit` parameter (implicit default is 10).
- If the value in `PinResults.count` is bigger than the length of `PinResults.results`, the client can infer there are more results that can be queried.
- To read more items, pass the `before` filter with the timestamp from `PinStatus.created` found in the oldest item in the current batch of results. Repeat to read all results.
- Returned results can be fine-tuned by applying optional `after`, `cid`, `name`, `status`, or `meta` filters.

> **Note**: pagination by the `created` timestamp requires each value to be globally unique. Any future considerations to add support for bulk creation must account for this.

21.0.0:á
x-logo}{url: https://bafybeidehxarrk54mkgyl5yxbgjzqilp6tkaz2or36jhq24n3rdtuven54.ipfs.dweb.link/?filename=ipfs-pinning-service.svg
%
#https://pinning-service.example.com"Ã
ı

/pinsÎ
"¬
pinsList pin objectsrList all the pin objects, matching optional filters; when no filter is provided, only successful pins are returned2
#/components/parameters/cid2 
#/components/parameters/name2!
#/components/parameters/match2" 
#/components/parameters/status2" 
#/components/parameters/before2!
#/components/parameters/after2!
#/components/parameters/limit2 
#/components/parameters/metaBùo
200h
f
'Successful response (PinResults object);
9
application/json%
#!
#/components/schemas/PinResults,
400%#
!#/components/responses/BadRequest.
401'%
##/components/responses/Unauthorized*
404#!
#/components/responses/NotFound3
409,*
(#/components/responses/InsufficientFunds4
4XX-+
)#/components/responses/CustomServiceError5
5XX.,
*#/components/responses/InternalServerError2£
pinsAdd pin object1Add a new pin object for the current access token::
84
2
application/json

#/components/schemas/PinBõm
202f
d
&Successful response (PinStatus object):
8
application/json$
" 
#/components/schemas/PinStatus,
400%#
!#/components/responses/BadRequest.
401'%
##/components/responses/Unauthorized*
404#!
#/components/responses/NotFound3
409,*
(#/components/responses/InsufficientFunds4
4XX-+
)#/components/responses/CustomServiceError5
5XX.,
*#/components/responses/InternalServerError
—
/pins/{requestid}ª"’
pinsGet pin objectGet a pin object and its statusBõm
200f
d
&Successful response (PinStatus object):
8
application/json$
" 
#/components/schemas/PinStatus,
400%#
!#/components/responses/BadRequest.
401'%
##/components/responses/Unauthorized*
404#!
#/components/responses/NotFound3
409,*
(#/components/responses/InsufficientFunds4
4XX-+
)#/components/responses/CustomServiceError5
5XX.,
*#/components/responses/InternalServerError2•
pinsReplace pin objectÆReplace an existing pin object (shortcut for executing remove and add operations in one step to avoid unnecessary garbage collection of blocks present in both recursive pins)::
84
2
application/json

#/components/schemas/PinBõm
202f
d
&Successful response (PinStatus object):
8
application/json$
" 
#/components/schemas/PinStatus,
400%#
!#/components/responses/BadRequest.
401'%
##/components/responses/Unauthorized*
404#!
#/components/responses/NotFound3
409,*
(#/components/responses/InsufficientFunds4
4XX-+
)#/components/responses/CustomServiceError5
5XX.,
*#/components/responses/InternalServerError:î
pinsRemove pin objectRemove a pin objectB„5
202.
,
*Successful response (no body, pin removed),
400%#
!#/components/responses/BadRequest.
401'%
##/components/responses/Unauthorized*
404#!
#/components/responses/NotFound3
409,*
(#/components/responses/InsufficientFunds4
4XX-+
)#/components/responses/CustomServiceError5
5XX.,
*#/components/responses/InternalServerErrorj"
 
	requestidpath R
	 string*Ø:
ó
∫

PinResults´
®∫count∫results object˙–
i
count`
^:1
 integeríCThe total number of pin objects that exist for passed query filtersöint32
c
resultsX
VêË† arrayÚ$
" 
#/components/schemas/PinStatusíAn array of PinStatus resultsí6Response used for listing pin objects matching request
Ç
	PinStatusÙ
Ò∫	requestid∫status∫created∫pin∫	delegates object˙ö
ß
	requestidô
ñ:UniqueIdOfPinRequest
 stringíqGlobally unique identifier of the pin request; can be used to check the status of ongoing pinning, or pin removal
)
status
#/components/schemas/Status
ø
created≥
∞:"2020-07-27T17:32:28Z"
 stringí}Immutable timestamp indicating when a pin request entered a pinning service; can be used for filtering results and paginationö	date-time
#
pin
#/components/schemas/Pin
/
	delegates" 
#/components/schemas/Delegates
+
info#!
#/components/schemas/StatusInfoíPin object with status
 
Pin¬
ø∫cid object˙ü
Z
cidS
Q:QmCIDToBePinned
 stringí1Content Identifier (CID) to be pinned recursively
j
nameb
`:PreciousData.pdf
xˇ stringí<Optional name for pinned data; can be used for lookups later
+
origins 
#/components/schemas/Origins
(
meta 
#/components/schemas/PinMetaí
Pin object
ª
Status∞
≠¬trqueued # pinning operation is waiting in the queue; additional info can be returned in info[status_details]      
¬YWpinning # pinning in progress; additional info can be returned in info[status_details]
¬pinned # pinned successfully
¬xvfailed # pinning service was unable to finish pinning operation; additional info can be found in info[status_details]
 stringí1Status a pin object can have at a pinning service
À
	DelegatesΩ
∫:20- /ip4/203.0.113.1/tcp/4001/p2p/QmServicePeerId
êò† arrayÚ

	 stringíbList of multiaddrs designated by pinning service for transferring any new data from external peers
–
Originsƒ
¡:ig- /ip4/203.0.113.142/tcp/4001/p2p/QmSourcePeerId
- /ip4/203.0.113.114/udp/4001/quic/p2p/QmSourcePeerId
ê† arrayÚ

	 stringí5Optional list of multiaddrs known to provide the data
∂
PinMeta™
ß:ecapp_id: 99986338-1113-4706-8302-4420da6158aa # Pin.meta[app_id], useful for filtering pins per app
 objectÇ

®Ë stringí Optional metadata for pin object
∏

StatusInfo©
¶:`^status_details: 'Queue position: 7 of 9' # PinStatus.info[status_details], when status=queued
 objectÇ

®Ë stringí$Optional info for PinStatus response
õ
TextMatchingStrategyÇ
ˇ¬<:exact # full match, case-sensitive (the implicit default)
¬(&iexact # full match, case-insensitive
¬*(partial # partial match, case-sensitive
¬-+ipartial # partial match, case-insensitive
 stringäexactí"Alternative text matching strategy
î
Failureà
Ö∫error object˙–
Õ
error√
¿∫reason object˙™
b
reasonX
V:ERROR_CODE_FOR_MACHINES
 stringí.Mandatory string identifying the type of error
√
details∑
¥:42Optional explanation for humans with more details
 stringírOptional, longer description of the error; may include UUID of transaction for support, links to documentation etcíResponse for a failed requestÿ	
Æ

BadRequestü
ú
Error response (Bad request)|
z
application/jsonf
 
#/components/schemas/FailureB
@
BadRequestExample+)
'#/components/examples/BadRequestExample
⁄
Unauthorized…
∆
AError response (Unauthorized; access token is missing or invalid)Ä
~
application/jsonj
 
#/components/schemas/FailureF
D
UnauthorizedExample-+
)#/components/examples/UnauthorizedExample
¡
NotFound¥
±
5Error response (The specified resource was not found)x
v
application/jsonb
 
#/components/schemas/Failure>
<
NotFoundExample)'
%#/components/examples/NotFoundExample
Ã
InsufficientFunds∂
≥
#Error response (Insufficient funds)ã
à
application/jsont
 
#/components/schemas/FailureP
N
InsufficientFundsExample20
.#/components/examples/InsufficientFundsExample
—
CustomServiceError∫
∑
%Error response (Custom service error)ç
ä
application/jsonv
 
#/components/schemas/FailureR
P
CustomServiceErrorExample31
/#/components/examples/CustomServiceErrorExample
‡
InternalServerError»
≈
1Error response (Unexpected internal server error)è
å
application/jsonx
 
#/components/schemas/FailureT
R
InternalServerErrorExample42
0#/components/examples/InternalServerErrorExampleá
ã
beforeÄ
~
beforequery9Return results created (queued) before provided timestampR
 stringö	date-timeZ"2020-07-27T17:32:28Z"

á
after~
|
afterquery8Return results created (queued) after provided timestampR
 stringö	date-timeZ"2020-07-27T17:32:28Z"

d
limit[
Y
limitqueryMax records to returnR2
0Y     @è@i      ? integerä		      $@öint32
 
cid¬
ø
cidqueryÌReturn pin objects responsible for pinning the specified CID(s); be aware that using longer hash functions introduces further constraints on the number of CIDs that will fit under the limit of 2000 characters per URL  in browser contexts:formR#
!ê
ò† arrayÚ

	 stringZ- Qm1
- Qm2
- bafy3

ë
nameà
Ö
namequeryQReturn pin objects with specified name (by default a case-sensitive, exact match)R
xˇ stringZPreciousData.pdf

’
matchÀ
»
matchquery˛Customize the text matching strategy applied when the name filter is present; exact (the default) is a case-sensitive exact match, partial matches anywhere in the name, iexact and ipartial are case-insensitive versions of the exact and partial strategiesR-+
)#/components/schemas/TextMatchingStrategyZexact

ß
statusú
ô
statusquery5Return pin objects for pins with the specified status:formR4
2ò† arrayÚ!

#/components/schemas/StatusZ- queued
- pinning

£
metaö
ó
metaqueryÕReturn pin objects that match specified metadata keys passed as a string representation of a JSON object; when implementing a client library, make sure the parameter is URL-encoded to ensure safe transportj8
6
application/json"
 
#/components/schemas/PinMeta"í
™
BadRequestExampleî
ë
6A sample response to a bad request; reason will differWUerror:
    reason: BAD_REQUEST
    details: Explanation for humans with more details

í
UnauthorizedExample{
y
#Response to an unauthorized requestRPerror:
    reason: UNAUTHORIZED
    details: Access token is missing or invalid

§
NotFoundExampleê
ç
8Response to a request for a resource that does not existQOerror:
    reason: NOT_FOUND
    details: The specified resource was not found

∑
InsufficientFundsExampleö
ó
+Response when access token run out of fundshferror:
    reason: INSUFFICIENT_FUNDS
    details: Unable to process request due to the lack of funds

º
CustomServiceErrorExampleû
õ
$Response when a custom error occuredsqerror:
    reason: CUSTOM_ERROR_CODE_FOR_MACHINES
    details: Optional explanation for humans with more details

≠
InternalServerErrorExampleé
ã
&Response when unexpected error occureda_error:
    reason: INTERNAL_SERVER_ERROR
    details: Explanation for humans with more details
:ò
ï
accessTokenÖ
Ç
httpÒ An opaque token is required to be sent with each request in the HTTP header:
- `Authorization: Bearer <access-token>`

The `access-token` should be generated per device, and the user should have the ability to revoke each token separately. *bearer2

accessToken 