# Custom CMaNGOS TBC kompilieren

Das Skript `contrib/server_scripts/build-cmangos-tbc.sh` konfiguriert, kompiliert und installiert den Core einschließlich AHBot und der vier Custom-Module.

## Standardaufruf

```bash
cd /home/matuph/source/cmangos/mangos-tbc
chmod +x contrib/server_scripts/build-cmangos-tbc.sh
./contrib/server_scripts/build-cmangos-tbc.sh
```

Das Skript verwendet automatisch sechs Jobs, wenn mindestens sechs CPU-Threads und ungefähr 8 GiB freier Arbeitsspeicher verfügbar sind. Auf kleineren Servern verwendet es vier Jobs. Bei weniger als vier CPU-Threads wird deren tatsächliche Anzahl verwendet.

Eine feste Jobzahl kann vorgegeben werden:

```bash
JOBS=4 ./contrib/server_scripts/build-cmangos-tbc.sh
```

oder:

```bash
JOBS=6 ./contrib/server_scripts/build-cmangos-tbc.sh
```

Mehr parallele Prozesse sind bei CMaNGOS nicht immer schneller: Wenn der Server zu wenig RAM besitzt und auslagern muss, dauert der Build deutlich länger oder wird vom Linux-Kernel beendet.

## Beschleunigte Folge-Builds

Ist `ccache` installiert, aktiviert das Skript automatisch den Compiler-Cache:

```bash
sudo apt update
sudo apt install ccache
```

Der Build-Ordner wird absichtlich wiederverwendet. Dadurch werden bei späteren Durchläufen nur geänderte Dateien neu kompiliert. Für einen vollständigen sauberen Build kann `/home/matuph/build` vorher manuell entfernt werden.

## Andere Verzeichnisse

```bash
SOURCE_DIR=/srv/cmangos/mangos-tbc \
BUILD_DIR=/srv/cmangos/build \
INSTALL_DIR=/srv/cmangos/server \
JOBS=6 \
./contrib/server_scripts/build-cmangos-tbc.sh
```

`USE_CCACHE=OFF` deaktiviert den Compiler-Cache. Mit `BUILD_TYPE=RelWithDebInfo` werden zusätzlich Debug-Informationen für aussagekräftigere Absturzprotokolle erzeugt.
