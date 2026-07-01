# CONNECT.CFG Suffix Note: July 1, 2026

This note records the first record-by-record decode pass over the stable retail
suffix found in `OPEN-R/MW/CONF/CONNECT.CFG`.

## Why This File Matters

The Sony OPEN-R Programmer's Guide says:

- `OBJECT.CFG` enumerates executable objects
- `CONNECT.CFG` describes subject/observer service connections

That makes `CONNECT.CFG` the most plausible retail config file for middleware
connection topology.

## What We Verified First

The same MIND 2 middleware `CONNECT.CFG` is present in all current MIND 2
baselines we compared:

- preserved repaired specimen image
- preserved MIND 2 reference image
- bundled `opt/AIBO7M2` tree

Observed hashes:

- MIND 2 MW `CONNECT.CFG`:
  `7377b33a43b8bbd99811c89d7a5d2f380995625f72d43fc78892f03445031d9c`
- MIND 3 MW `CONNECT.CFG`:
  `c29bc50bca2d3b55f4dcd9d7252a511cc3da61d0514e25330c4705707c0ed86c`

So the current decode pass is anchored to the preserved working MIND 2 lineage,
not only to a convenience tree under `opt/`.

## Stable Suffix Boundary

Comparing MIND 2 and MIND 3 MW `CONNECT.CFG` files shows:

- bytes `0-511` differ
- bytes `512-919` are identical
- the stable suffix length is `408` bytes
- `408 = 17 x 24`

That stable suffix can therefore be decoded as `17` candidate `24`-byte
records.

An even stronger framing also fits the arithmetic exactly:

- total file size: `920` bytes
- first `8` bytes: a likely prelude or header fragment
- remaining `912` bytes: exactly `38 x 24`

Under that model, retail MW `CONNECT.CFG` is plausibly:

- `8` bytes of prelude
- followed by `38` aligned `24`-byte records

This model explains the stable region cleanly:

- records `0-20` differ across MIND 2 and MIND 3
- records `21-37` are byte-identical across both versions

That is a much cleaner statement than only saying "bytes `512-919` match."

This shape does not appear to be unique to `MW/CONF/CONNECT.CFG`.

Additional retail files with the same `8-byte prelude + 24-byte records`
layout include, for example:

- MIND 2 `MW/CONF/DESIGNDB.CFG`: `584 = 8 + (24 x 24)`
- MIND 2 `APP/CONF/OBJECT.CFG`: `224 = 8 + (24 x 9)`
- MIND 2/MIND 3 `MW/CONF/AUDIO.CFG`: `104 = 8 + (24 x 4)`
- MIND 2/MIND 3 `MW/CONF/CAMERA.INF`: `224 = 8 + (24 x 9)`
- MIND 2/MIND 3 `MW/CONF/GAIN.CFG`: `128 = 8 + (24 x 5)`
- MIND 2/MIND 3 `MW/CONF/IC.CFG`: `128 = 8 + (24 x 5)`
- MIND 2/MIND 3 `MW/CONF/MPACC.CFG`: `968 = 8 + (24 x 40)`
- MIND 2/MIND 3 `MW/CONF/OR.CFG`: `656 = 8 + (24 x 27)`

So the current best family model is not merely "retail configs are 8-byte
aligned." It is stronger:

- at least one major Sony retail config family appears to use
  `8-byte prelude + N x 24-byte record payload`

One caution is important here:

- many other repeated `first8` values in the repo begin with `1f8b08...`
- those are consistent with gzip-style wrappers and should not be mixed up with
  the opaque `CONNECT.CFG` / `DESIGNDB.CFG` family clue

The most relevant non-gzip repeated preludes we have seen so far are still:

- MIND 2 `MW/CONF/CONNECT.CFG` and `MW/CONF/DESIGNDB.CFG`:
  `0e207d53993b8df4`
- MIND 2 `SYSTEM/CONF/EXTOBJ.CFG` and `SYSTEM/CONF/CARDDRV.CFG`:
  `9073ab72cf85c9bb`
- MIND 3 `SYSTEM/CONF/EXTOBJ.CFG` and `SYSTEM/CONF/CARDDRV.CFG`:
  `08494436c1d67f88`

That keeps the `CONNECT.CFG` / `DESIGNDB.CFG` pairing interesting, but also
warns us not to overread every repeated `first8` as the same kind of signal.

We now have a stronger version of that caution:

- many files with the same `8 + (24 x N)` arithmetic are in fact gzip-wrapped
  payloads
- in those cases, the first `8` bytes behave like gzip header metadata while
  the remaining payload is stable or partially stable

Control examples:

- `MW/CONF/OR.CFG`
  - `656 = 8 + (24 x 27)`
  - bytes `8-655` are identical across MIND 2 and MIND 3
  - only the first `8` bytes differ
- `MW/CONF/MPACC.CFG`
  - `968 = 8 + (24 x 40)`
  - bytes `8-967` are identical across MIND 2 and MIND 3
  - only the first `8` bytes differ
- `APP/CONF/CCAPPC.CFG`
  - `104 = 8 + (24 x 4)`
  - bytes `8-103` are identical across MIND 2 and MIND 3
  - only the first `8` bytes differ

This is useful because it makes `MW/CONF/CONNECT.CFG` look more special, not
less:

- it is one of the rare non-gzip files in this arithmetic family
- and it is one of the rare files where the post-byte-`8` payload is split into
  a changing front section and a stable trailing section

## Record Decode Pass

Tool:

- [scripts/decode-retail-connect-suffix.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/decode-retail-connect-suffix.sh)
- [scripts/analyze-retail-connect-table.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/analyze-retail-connect-table.sh)

Example:

```bash
scripts/decode-retail-connect-suffix.sh \
  opt/AIBO7M2/OPEN-R/MW/CONF/CONNECT.CFG \
  opt/AIBO7M3/OPEN-R/MW/CONF/CONNECT.CFG
```

Whole-table view using the same decoder:

```bash
scripts/decode-retail-connect-suffix.sh --start-byte 8 \
  opt/AIBO7M2/OPEN-R/MW/CONF/CONNECT.CFG
```

Partition view:

```bash
scripts/analyze-retail-connect-table.sh \
  opt/AIBO7M2/OPEN-R/MW/CONF/CONNECT.CFG \
  opt/AIBO7M3/OPEN-R/MW/CONF/CONNECT.CFG \
  opt/AIBO7M2/OPEN-R/MW/OBJS
```

Observed structural properties:

1. The suffix decodes cleanly into exactly `17` records of `24` bytes each.
2. All `17` full records are unique.
3. Each of the six little-endian `u32` columns also has `17` unique values.
4. There are no obvious all-zero records, small counters, or repeated sentinel
   rows.
5. The records also look dense in `3 x 8`-byte grouping, not sparse.
6. If we decode from byte `8`, the whole remaining file becomes `38` clean
   `24`-byte records.
7. In that aligned record view, the exact same-position shared span is:
   - record `21` through record `37`
   - `17` identical records total
8. All `38` aligned post-byte-`8` records are unique within each version.
9. The first `21` records and the stable last `17` records are completely
   disjoint at the tested chunk levels:
   - no shared `24`-byte records
   - no shared `8`-byte sub-blocks
   - no shared `4`-byte values
10. The stable record count does not collapse to the unchanged MW object count:
    - stable records: `17`
    - unchanged MW object binaries: `12`
    - difference: `5`

That is important because it argues against the first section simply storing
small integer references into the stable tail in an obvious unencoded form.
It also argues against the stable tail being only a one-record-per-object list.

This weakens the simplest hypothesis that the suffix is only a trivial object
index table with small integer fields.

## Preliminary Interpretation

The current evidence is more consistent with one of these models:

1. compiled service-connection records that use opaque numeric identifiers
2. hashed or tokenized subject/observer names rather than plain indexes
3. a two-section compiled table where:
   - an `8`-byte prelude starts the file
   - the first `21` records are version-specific
   - the last `17` records are a stable shared middleware subset
4. a binary table whose fields only become meaningful when interpreted together
   with another retail config such as `OBJECT.CFG`, `SERVICE.CFG`, or
   `DESIGNDB.CFG`
5. a wider retail record family where multiple config types share the same
   low-level container shape but not the same payload semantics
6. a mixed family in which some members are gzip-wrapped content files while a
   smaller subset, including `CONNECT.CFG`, are opaque non-gzip compiled tables
7. a stable middleware connection graph or service subset that is richer than a
   plain MW object roster, since `17` stable records do not map 1:1 to the `12`
   unchanged MW object binaries

It is less consistent with:

- plain-text service names
- a short flag table
- simple sequential object numbers only

## SERVICE.CFG Comparison

We also checked whether `MW/CONF/SERVICE.CFG` looks like a direct naming or
classification companion for the stable `CONNECT.CFG` suffix.

What we found:

- `SERVICE.CFG` is also aligned to `24`-byte records
  - MIND 2: `528` bytes = `22 x 24`
  - MIND 3: `576` bytes = `24 x 24`
- all `24`-byte records in each version are unique
- each little-endian `u32` column is fully unique within each version
- MIND 2 and MIND 3 `SERVICE.CFG` share:
  - no same-position equal spans
  - no shared `8`-byte blocks anywhere
  - no shared `24`-byte records anywhere
- the stable `17` `CONNECT.CFG` suffix records share:
  - no `24`-byte records with MIND 2 `SERVICE.CFG`
  - no `24`-byte records with MIND 3 `SERVICE.CFG`

So `SERVICE.CFG` still looks like a member of the same broad opaque Sony
retail config family, but not like a literal copy, suffix, or straightforward
record reuse of the stable `CONNECT.CFG` tail.

That pushes the current working model toward:

- sibling compiled tables with different roles
- an `8`-byte prelude plus aligned `24`-byte record payload in
  `MW/CONF/CONNECT.CFG`
- a broader retail family using the same low-level layout in multiple files
- or a shared transform/container applied to different semantic payloads

rather than:

- one file simply naming the records embedded in the other
- or one file containing an unchanged subset copied from the other

## DESIGNDB.CFG Comparison

`MW/CONF/DESIGNDB.CFG` remains the closest same-family comparison candidate.

What we found:

- MIND 2 `DESIGNDB.CFG` fits the same strong container shape:
  - `584 = 8 + (24 x 24)`
  - first `8` bytes match MIND 2 `CONNECT.CFG` exactly:
    `0e207d53993b8df4`
- MIND 3 `DESIGNDB.CFG` does **not** keep that exact same framing:
  - `624` bytes = `26 x 24`
  - the first `8` bytes differ from MIND 2 and from MIND 3 `CONNECT.CFG`
- Across MIND 2 and MIND 3 `DESIGNDB.CFG`, we found:
  - no same-position equal spans
  - no shared `8`-byte blocks anywhere
  - no shared `24`-byte records under the tested alignments
- Within MIND 2, `CONNECT.CFG` and `DESIGNDB.CFG` share:
  - the same first `8` bytes
  - but no shared aligned `24`-byte records
  - and no shared `8`-byte record sub-blocks in their payloads

So `DESIGNDB.CFG` strengthens the idea of a broader retail container family,
but weakens the simplest reading of the shared prelude:

- the shared MIND 2 prelude is probably not enough, by itself, to mean
  "same payload semantics"
- it may instead identify a family variant, build container, or transform mode
  that can wrap different record tables

## Gzip Control Cases

To avoid overfitting the `CONNECT.CFG` result, we compared several smaller
same-shape files that also satisfy `8 + (24 x N)`.

The important observation is that many of them look like gzip-wrapped payloads,
not like opaque retail tables:

- `MW/CONF/OR.CFG`
- `MW/CONF/MPACC.CFG`
- `APP/CONF/CCAPPC.CFG`
- and many related files whose first bytes begin with `1f8b08`

For these control cases, the common pattern is:

- the first `8` bytes differ across versions
- the full remaining payload is byte-identical

That is very different from `MW/CONF/CONNECT.CFG`, where:

- the file is not gzip-like
- the first `21` aligned records differ
- the last `17` aligned records are identical

So the current best reading is:

- `8 + (24 x N)` alone is not enough to identify an opaque compiled table
- non-gzip status is an important filter
- `CONNECT.CFG` remains unusual inside the broader family

## Additional Non-Gzip Checks

We also checked the next most promising non-gzip candidates:

- `MW/CONF/DESIGN.CFG`
- `SYSTEM/CONF/EXTOBJ.CFG`
- `SYSTEM/CONF/CARDDRV.CFG`

### DESIGN.CFG

Observed structure:

- MIND 2: `56 = 8 + (24 x 2)`
- MIND 3: `56 = 8 + (24 x 2)`
- no same-position equal spans across versions
- no shared `8`-byte blocks anywhere across versions
- no shared `24`-byte records across versions

So `DESIGN.CFG` behaves like a fully changed tiny opaque table, not like a
`CONNECT.CFG`-style mixed stable/versioned table.

### EXTOBJ.CFG and CARDDRV.CFG

Observed structure:

- `EXTOBJ.CFG`: `96` bytes = `4 x 24`
- `CARDDRV.CFG`: `120` bytes = `5 x 24`
- both files change completely across MIND 2 and MIND 3
- no same-position equal spans across versions
- no shared `8`-byte blocks anywhere across versions

Within a single version, each pair still shares exactly one `8`-byte block:

- MIND 2: `9073ab72cf85c9bb`
- MIND 3: `08494436c1d67f88`

But they share:

- no `24`-byte records within the pair
- no payload `8`-byte blocks beyond that first shared block

That reinforces the idea that the shared leading `8` bytes are likely acting as
some sort of family/header marker, not as evidence that the two files embed the
same record payload.

## Current Subgroup Picture

At this point, the opaque non-gzip family seems to split into at least three
behaviors:

1. `CONNECT.CFG`
   - `8 + (24 x 38)` structure
   - mixed version-specific front section plus stable trailing section
2. `DESIGNDB.CFG`, `DESIGN.CFG`, `EXTOBJ.CFG`, `CARDDRV.CFG`
   - opaque non-gzip files
   - no stable cross-version records found so far
   - some repeated first `8` bytes within a version
3. gzip-wrapped controls such as `OR.CFG`, `MPACC.CFG`, `CCAPPC.CFG`
   - first `8` bytes vary
   - post-byte-`8` payload remains stable

This makes `CONNECT.CFG` the strongest special case in the current dataset.

## Why This Still Helps

Even without field names yet, this is progress:

- we now have a stable retail middleware table candidate
- it is invariant across preserved MIND 2 specimens
- it survives into MIND 3 as an identical trailing section
- it gives the simulator work a concrete structure to target rather than a
  vague "Sony internal logic" placeholder

## Simulator Swap Boundary

We also ran a direct host-side swap experiment:

- control tree: specimen-style tree with retail MIND 2 `MW/CONF/CONNECT.CFG`
- swap tree: identical tree except `MW/CONF/CONNECT.CFG` replaced with the
  retail MIND 3 version

Observed hashes:

- control `CONNECT.CFG`:
  `7377b33a43b8bbd99811c89d7a5d2f380995625f72d43fc78892f03445031d9c`
- swap `CONNECT.CFG`:
  `c29bc50bca2d3b55f4dcd9d7252a511cc3da61d0514e25330c4705707c0ed86c`

Current simulator result:

- the simulator now distinguishes the known retail variants in profile output
  as:
  - `retail-mind2-known`
  - `retail-mind3-known`
- but the shutdown-probe scenario outcome did not change under the current
  heuristic

Current interpretation:

- the simulator is now sensitive to the variant identity
- but the present behavior model only uses the shared `21/17` partition as a
  weak plausibility signal
- therefore a single-file retail MIND 2 vs MIND 3 `CONNECT.CFG` swap does not
  yet alter the host-side verdict

This is a useful conclusion boundary:

- `CONNECT.CFG` is structurally important enough to model
- but the current simulator has not yet reached a variant-specific behavioral
  interpretation for it

## Immediate Next Questions

1. Do any `24`-byte suffix records correlate with counts or ordering implied by
   sample OPEN-R subject/observer service declarations?
2. Can we align these `17` records with any stable subset of MW objects or
   service definitions?
3. What exactly are the first `21` post-byte-`8` records doing, and why do
   they change completely between MIND 2 and MIND 3?
4. Is the leading `8`-byte prelude a header key, type marker, or record-family
   discriminator?
5. Do `OBJECT.CFG`, `SERVICE.CFG`, and `CONNECT.CFG` share a higher-level
   record/key scheme even though their payload records do not match directly?
6. Which other `8 + (24 x N)` retail config files are best suited for
   cross-version comparison to infer the meaning of the common container?
7. Why does MIND 2 `DESIGNDB.CFG` share the `CONNECT.CFG` prelude while MIND 3
   `DESIGNDB.CFG` shifts to a different framing?
8. Besides `CONNECT.CFG` and `DESIGNDB.CFG`, which non-gzip family members are
   the next best candidates for opaque-table decoding?
9. Why is `CONNECT.CFG` the only current non-gzip family member showing a large
   stable cross-version tail?
10. What additional semantics would let the simulator distinguish
    `retail-mind2-known` from `retail-mind3-known` `CONNECT.CFG` variants in a
    behaviorally meaningful way?
