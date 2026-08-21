# Custom C++ patches

This directory keeps optional C++ services out of the CMaNGOS core source tree.

## Available patches

| Patch | Services | Required database custom SQL |
| --- | --- | --- |
| `0001-buffer-and-playertreff-services.patch` | Standard Buffer (`90001`), Premium Buffer (`90033`), and Playertreff profession trainer (`90019`) | `tbc-db/Custom/Optional/9001_npc_buffer.sql`, `9002_playertreff.sql`, and `9003_premium_buffer.sql` |

`npc_level58_upgrade.lua` is deliberately not a C++ patch: it remains an Eluna/Lua service in `lua_scripts/` and is configured by `sql/custom/optional/npc_level58_upgrade.sql`.

## Applying a patch

Apply the patch from the root of a clean checkout, then configure and rebuild with ScriptDevAI enabled:

```text
git apply --check patches/custom/0001-buffer-and-playertreff-services.patch
git apply patches/custom/0001-buffer-and-playertreff-services.patch
```

The patch adds only custom service files and their explicit ScriptDevAI registration. It does not replace or remove CMaNGOS scripts. Import the matching optional SQL before spawning the NPCs.

## Removing a patch

```text
git apply --reverse patches/custom/0001-buffer-and-playertreff-services.patch
```
