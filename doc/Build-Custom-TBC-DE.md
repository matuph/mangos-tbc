# Custom CMaNGOS TBC kompilieren

Das Skript `contrib/server_scripts/build-cmangos-tbc.sh` konfiguriert, kompiliert und installiert den Core einschließlich AHBot und der vier Custom-Module.

## Standardaufruf

```bash
cd /home/matuph/source/cmangos/mangos-tbc
chmod +x contrib/server_scripts/build-cmangos-tbc.sh
./contrib/server_scripts/build-cmangos-tbc.sh
```

Das Skript verwendet standardmäßig 16 parallele Compiler-Prozesse für einen Server mit 16 CPU-Threads. Mit JOBS lässt sich die Anzahl bei Bedarf reduzieren.

## Zweite und weitere Installationen

Ohne Argument wird Server 2 gebaut: Build-Verzeichnis `/home/matuph/build-2`, Installation `/home/matuph/wow-emu/wow-tbc-2`. Alle Installationen verwenden dieselbe Core-Source, aber eigene Build-Verzeichnisse und Installationsziele.

```bash
# Zweite Installation (Standard)
bash contrib/server_scripts/build-cmangos-tbc.sh 2

# Dritte oder vierte Installation
bash contrib/server_scripts/build-cmangos-tbc.sh 3
bash contrib/server_scripts/build-cmangos-tbc.sh 4

# Nur die Zielpfade anzeigen, ohne Dateien anzulegen oder zu bauen
bash contrib/server_scripts/build-cmangos-tbc.sh 3 --dry-run
```

Server 3 verwendet `build-3` und `wow-tbc-3`, Server 4 entsprechend `build-4` und `wow-tbc-4`. Server 1 verwendet die ursprünglichen Verzeichnisse `build` und `wow-tbc`. Alternativ ist `SERVER_ID=3` möglich; eine Nummer als Argument hat Vorrang. Explizite `BUILD_DIR`- und `INSTALL_DIR`-Variablen überschreiben die abgeleiteten Pfade.

Das Skript baut und installiert die Software. Es richtet keine Datenbanken, Realm-Einträge oder laufenden Dienste ein. Für gleichzeitigen Betrieb müssen pro Realm eigene World-/Characters-Datenbanken, Realm-ID, World-Port sowie passende Konfiguration und Spieldaten eingerichtet werden. Ein gemeinsamer Authentifizierungsserver mit gemeinsamer Realmd-Datenbank kann mehrere Realms bedienen.

Eine feste Jobzahl kann vorgegeben werden:

```bash
JOBS=8 ./contrib/server_scripts/build-cmangos-tbc.sh
```

oder:

```bash
JOBS=16 ./contrib/server_scripts/build-cmangos-tbc.sh
```

Mehr parallele Prozesse sind bei CMaNGOS nicht immer schneller: Wenn der Server zu wenig RAM besitzt und auslagern muss, dauert der Build deutlich länger oder wird vom Linux-Kernel beendet.

## Beschleunigte Folge-Builds

Ist `ccache` installiert, aktiviert das Skript automatisch den Compiler-Cache:

```bash
sudo apt update
sudo apt install ccache
```

Der zur Servernummer gehörende Build-Ordner wird wiederverwendet, für Server 2 also `/home/matuph/build-2`. Dadurch werden bei späteren Durchläufen nur geänderte Dateien neu kompiliert.

## Andere Verzeichnisse

```bash
SOURCE_DIR=/srv/cmangos/mangos-tbc \
BUILD_DIR=/srv/cmangos/build \
INSTALL_DIR=/srv/cmangos/server \
JOBS=16 \
./contrib/server_scripts/build-cmangos-tbc.sh
```

`USE_CCACHE=OFF` deaktiviert den Compiler-Cache. Mit `BUILD_TYPE=RelWithDebInfo` werden zusätzlich Debug-Informationen für aussagekräftigere Absturzprotokolle erzeugt.
