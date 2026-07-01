# Key Research Questions

## Core Questions

1. Which persistent files correlate with distinctive higher-order MIND 2
   behaviors on real hardware?
2. Are those behaviors reproducible when the same image is cloned to other
   compatible sticks?
3. Are those behaviors preserved across imaging, restoration, and redeployment?
4. Which behaviors are stable and which are sensitive to context, time, or
   robot history?
5. Are some behaviors tied to robot identity or calibration rather than only
   stick contents?

## Immediate Questions

1. What exactly does "doesn't like to be turned off" mean operationally?
2. Does that behavior repeat across multiple shutdown attempts in the same
   environment?
3. Does it persist if the repaired image is written to another Sony 32 MB class
   stick?
4. Which files differ most strongly between the repaired specimen and the other
   comparison MIND 2 sticks?
5. Which of those differing files are plain text, structured, or easy to
   classify before binary reverse-engineering?
6. Can the stable `17 x 24` suffix in retail `MW/CONF/CONNECT.CFG` be mapped
   to a reproducible middleware connection graph?
7. Is `MW/CONF/SERVICE.CFG` a sibling compiled table with its own role, rather
   than a direct label map for `CONNECT.CFG`?
8. Why do `17` stable `CONNECT.CFG` records survive when the unchanged MW
   object roster is only `12` binaries?
9. Does `STTLOG` act as the dominant current host-side behavior lever in the
   simulator, ahead of `PAT.LOG`, `FVAR`, and `GVAR`?
10. Is the effective current `STTLOG` shutdown subset primarily
    `0300/0400/1000/1200`, with `0046` acting as a separate social modifier?
11. Does `1200` behave more like a bridge/social row, while `0300/0400/1000`
    carry most of the current shutdown-resistance weight?
12. Under the fatigue-first shutdown probe, are `0300/0400/1000` already
    sufficient as the decisive current shutdown verdict subset?

## Experimental Questions

1. If `AWAKING.CFG` alone is swapped, does shutdown or wake behavior change?
2. If the `RVAR`/`GVAR`/`FVAR` cluster is swapped together, does the distinctive
   behavior follow the cluster?
3. If the whole `OPEN-R/APP/DATA/P/` tree is transplanted onto another known
   good MIND 2 baseline, does the behavior transfer?
4. If only `OWNER.TXT` or owner-facing config files differ, do we see merely
   cosmetic changes or deeper behavioral ones?
5. Which files can be changed without breaking boot, and which appear critical?
6. Does distinctive behavior transfer when the differing app-state files are
   transplanted without `AIBO-ID`?
7. Does the behavior transfer more strongly when `AIBO-ID` is transplanted
   together with the app-state cluster?
8. Can a host-side decoded retail MW connection graph improve simulator
   predictions before hardware trials?
9. Can the `21` versioned vs `17` stable record partition in retail
   `CONNECT.CFG` be used as an explicit simulator feature boundary?
10. If `STTLOG` alone is reverted or transplanted, does the simulated shutdown
    and social profile move more strongly than for the `PAT.LOG + FVAR + GVAR`
    cluster?
11. If only `0300`, `0400`, `1000`, and `1200` are changed, can we isolate the
    shutdown profile without collapsing the whole specimen-style behavior
    signature?
12. Do we need a sharper scenario or threshold change so that the row-level
    `STTLOG` splits alter the final shutdown verdict, not only the profile
    signals?
13. Does the fatigue-first probe provide the right discriminator for future
    STTLOG row experiments, replacing the older shutdown probe as the main
    host-side test?

## Preservation Questions

1. What is the minimal artifact set needed to preserve a distinctive MIND 2
   behavioral specimen?
2. Should we preserve only full raw images, or also extracted persistent-state
   trees and per-file hashes for faster comparison?
3. What metadata must accompany every future behavioral specimen so another
   agent can reproduce the test conditions?
