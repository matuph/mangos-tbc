# Flekz module-system patch for the current TBC core

`tbc-current.patch` contains only the Flekz framework integration and core hook changes. Module source trees and custom service modules are deliberately not embedded in this patch.

Base used when regenerating the patch: local `feature/playertreff` after rebasing onto `origin/master` commit `220fcdd` (2026-08-22).

Apply from the root of the matching CMaNGOS TBC checkout:

```text
git apply --check patches/flekz/tbc-current.patch
git apply patches/flekz/tbc-current.patch
```

Then place the Flekz framework and desired modules under `src/modules` and configure with `-DBUILD_MODULES=ON` plus the relevant `-DBUILD_MODULE_<NAME>=ON` flags.

SHA-256: `FF40B190733B2821E0628BACB50A5FDD7CE9EB39DF96AEEF0069FAD9F413548D`
