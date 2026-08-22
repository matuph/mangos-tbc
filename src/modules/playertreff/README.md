# Playertreff (CMaNGOS TBC)

Flekz module package for the SQL-first Playertreff. It provides vendors for armor, weapons, gems/jewelry, bags, mounts and separated profession materials; a guild bank NPC; all nine TBC class trainers; all thirteen profession trainers; a class-aware weapon-skill service; standard/premium buffers; and portal logic.

## Install

1. Configure with `-DBUILD_MODULES=ON -DBUILD_MODULE_PLAYERTREFF=ON`.
2. Import `sql/install/world/playertreff.sql` into the world database.
3. Ensure Eluna loads `src/lua_scripts/playertreff_services.lua` (CMake installs it into `lua_scripts`).
4. Spawn only the desired entries with `.npc add <entry>`; the installer deliberately creates no fixed world spawns.

Uninstall with `sql/uninstall/world/playertreff.sql`. The SQL is idempotent for module-owned entries.

The portal destination named "Playertreff" is intentionally represented by the service NPC itself. Adjust coordinates in the Lua file when the final meeting-point map and coordinates are known.
