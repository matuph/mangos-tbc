# Level 58 Upgrade (CMaNGOS TBC)

Independent Flekz/Eluna module. NPC `90005` upgrades characters below level 58 to level 58 for exactly 120,000 gold (`1,200,000,000` copper) and grants the eight class-appropriate Dungeon Set 1 pieces. All nine TBC classes are covered.

## Install

1. Configure with `-DBUILD_MODULES=ON -DBUILD_MODULE_LEVEL58UPGRADE=ON`.
2. Import `sql/install/world/level58_upgrade.sql` into the world database.
3. Ensure Eluna loads `src/lua_scripts/level58_upgrade.lua` (CMake installs it into `lua_scripts`).
4. Spawn NPC `90005` with `.npc add 90005`.

The Lua handler performs server-side level and money checks, rolls back newly added items on inventory failure, charges only after all pieces were added, then saves the character. Uninstall with `sql/uninstall/world/level58_upgrade.sql`.
