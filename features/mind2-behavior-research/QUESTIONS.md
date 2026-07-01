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
13. Is `0400` the primary current shutdown pivot, with `0300` and `1000`
    acting only as secondary contributors unless `0400` also changes?
14. Does `0400` remain decisive only under the fatigue-first probe, while the
    older shutdown probe is too engagement-rich to expose it at the verdict
    level?
15. If specimen `0400` alone is transplanted into a baseline tree, does the
    fatigue-first shutdown verdict shift in the forward direction as well?
16. On leaner MIND 2 baselines, does `0400` require `1200` as a bridge/social
    companion to cross the shutdown verdict boundary?
17. Does `1200` have any independent shutdown effect at all, or only a bridge
    role that amplifies `0400`?
18. Do the current modeled alternatives `0046` and `0055` fail to substitute
    for `1200`, making `0400 + 1200` the strongest current minimal pair?
19. Do the remaining differing non-`STTLOG` specimen files fail to substitute
    for `1200` only because of the current heuristic, or is that likely to
    hold after richer modeling?
20. Once `IEG.CFG` gets explicit semantics, does specimen `0400 + IEG.CFG`
    become a second current bridge path on lean baselines, while `SIDRDATA.BIN`
    still does not?
21. After calibration, does `IEG.CFG` remain a companion bridge signal rather
    than becoming a standalone shutdown trigger on stronger baselines?
22. Are `1200` and calibrated `IEG.CFG` genuinely parallel bridge signals, or
    do alternate scenarios show a stable difference between social-weighted and
    rigidity-weighted bridge paths?

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
14. If `0400` alone flips the fatigue-first verdict, does it still dominate
    under other plausible shutdown scenarios, or only at this sharper boundary?
15. If `0400` is transplanted into a leaner baseline, what is the minimal
    companion set needed to restore shutdown deferral: `1200` alone, `0046`
    alone, or some other small row group?
16. Is `0400 + 1200` the minimal current pair for lean-baseline shutdown
    deferral, with `0046` only increasing social weight but not changing the
    verdict boundary?
17. Are there any remaining currently modeled row combinations that can match
    `0400 + 1200`, or have we reached the present simulator-side minimal pair
    boundary?
18. Should the next simulator iteration give `IEG.CFG`, `SIDRDATA.BIN`, `FVAR`,
    or `GVAR` explicit shutdown/social semantics before we draw a harder
    conclusion about their ability to substitute for `1200`?
19. Is the current `IEG.CFG` sparse-pattern heuristic the right first explicit
    non-`STTLOG` semantic hook, or should it be narrowed or reweighted before
    further conclusions are drawn?

## Preservation Questions

1. What is the minimal artifact set needed to preserve a distinctive MIND 2
   behavioral specimen?
2. Should we preserve only full raw images, or also extracted persistent-state
   trees and per-file hashes for faster comparison?
3. What metadata must accompany every future behavioral specimen so another
   agent can reproduce the test conditions?
