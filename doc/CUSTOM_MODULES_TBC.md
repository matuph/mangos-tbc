# Local TBC module bundle

This checkout vendors the Flekz module framework and four independently selectable modules under `src/modules`.

## Configure

```text
cmake -S . -B build \
  -DBUILD_MODULES=ON \
  -DBUILD_MODULE_PLAYERTREFF=ON \
  -DBUILD_MODULE_LEVEL58UPGRADE=ON \
  -DBUILD_MODULE_HARDCORE=ON \
  -DBUILD_MODULE_TRAININGDUMMIES=ON
cmake --build build --config RelWithDebInfo
```

Vendored module sources are preferred over network downloads and are retained when a module is disabled.

## Database and runtime

- Import `src/modules/playertreff/sql/install/world/playertreff.sql` into the world DB.
- Import `src/modules/level58upgrade/sql/install/world/level58_upgrade.sql` into the world DB.
- Import Hardcore SQL from its `sql/install/world` and `sql/install/characters` directories.
- Import `src/modules/trainingdummies/sql/install/world/world_tbc.sql` into the world DB.
- Copy `hardcore.conf.dist` and `trainingdummies.conf.dist` from the build/install output beside `mangosd.conf`, remove `.dist`, and enable the desired settings.
- Ensure the Eluna loader uses the installed `lua_scripts` directory. Playertreff and Level58Upgrade Lua files are installed there by their CMake targets.

No custom service NPC receives a forced spawn. Use `.npc add ENTRY` at the chosen meeting point. Relevant entries are documented in each module README and in the Playertreff installer.

## Removal

Disable the corresponding `BUILD_MODULE_*` flag, rebuild, and execute the SQL in that module's `sql/uninstall` directories. Remove its runtime config/Lua file from the server output as applicable.

## Provenance

- Framework: `flekz-games/cmangos-modules`, revision `f917cf5338d4eae191cb45fa6928db6941154670`.
- Hardcore: `flekz-games/cmangos-hardcore`, revision `fe5033afe516f10501bea515d1b8e8b4dd0933fa`.
- TrainingDummies: `flekz-games/cmangos-trainingdummies`, revision `d00323521680b76eebbe03d9c498c84ec85e7bbf`.
