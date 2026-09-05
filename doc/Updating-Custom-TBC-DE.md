# Custom CMaNGOS TBC aktualisieren

Das Skript `contrib/server_scripts/update-cmangos-sources.sh` aktualisiert den lokalen Core und die lokale TBC-Datenbank aus den offiziellen CMaNGOS-Repositories. Die eigenen Module, Patches und SQL-Dateien bleiben dabei Bestandteil der aktuell ausgecheckten Feature-Branches.

## Erwartete Verzeichnisstruktur

Standardmäßig erwartet das Skript beide Repositories nebeneinander:

```text
/home/matuph/source/cmangos/
├── mangos-tbc/
└── tbc-db/
```

Das Skript liegt im Core und erkennt dessen Pfad automatisch. Ein abweichender Datenbankpfad kann mit `--db-path` angegeben werden.

## Vorbereitung

Beide Repositories müssen einen sauberen Arbeitsstand besitzen. Eigene Änderungen daher zuerst committen oder mit Git sichern. Das Skript bricht andernfalls ab und verändert nichts.

```bash
cd /home/matuph/source/cmangos/mangos-tbc
git status

cd /home/matuph/source/cmangos/tbc-db
git status
```

## Verfügbare Aktualisierungen prüfen

```bash
cd /home/matuph/source/cmangos/mangos-tbc
chmod +x contrib/server_scripts/update-cmangos-sources.sh
./contrib/server_scripts/update-cmangos-sources.sh --check
```

`--check` lädt nur die Git-Informationen herunter und verändert keinen lokalen Branch.

## Core und Datenbank aktualisieren

```bash
cd /home/matuph/source/cmangos/mangos-tbc
./contrib/server_scripts/update-cmangos-sources.sh
```

Das Skript führt folgende Schritte aus:

1. Prüfung auf nicht gespeicherte Änderungen in beiden Repositories.
2. Einrichtung beziehungsweise Aktualisierung des Remotes `upstream`.
3. Abruf der eigenen `origin`-Repositories und der offiziellen CMaNGOS-Repositories.
4. Sicheres Fast-Forward des jeweils ausgecheckten Branches auf dessen Stand bei `origin`.
5. Lokaler Merge von `upstream/master` in die jeweils ausgecheckten Custom-Branches.
6. Aktualisierung der Core-Unterprojekte (Git-Submodule).

Vor der Aktualisierung wird in jedem Repository ein lokales Tag nach dem Muster `backup/before-update-YYYYMMDD-HHMMSS` erstellt. Das Skript führt keinen automatischen Push zu GitHub aus.

Für einen abweichenden Datenbankpfad:

```bash
./contrib/server_scripts/update-cmangos-sources.sh --db-path /srv/source/tbc-db
```

Submodule können bei Bedarf ausgelassen werden:

```bash
./contrib/server_scripts/update-cmangos-sources.sh --no-submodules
```

## Merge-Konflikt behandeln

Bei einem Konflikt stoppt das Skript. Die betroffenen Dateien können geprüft und anschließend gespeichert werden:

```bash
git status
git add <korrigierte-dateien>
git commit
```

Soll der begonnene Merge vollständig verworfen werden:

```bash
git merge --abort
```

Der Datenbank-Merge wird erst begonnen, nachdem der Core-Merge erfolgreich abgeschlossen wurde. Deshalb nach einem Konflikt immer den Status beider Repositories prüfen.

## Neu kompilieren

Nach einem Core-Update wird ein sauberer Build empfohlen:

```bash
cd /home/matuph
rm -rf build
mkdir build
cd build

cmake ../source/cmangos/mangos-tbc \
  -DCMAKE_INSTALL_PREFIX=/home/matuph/wow-emu/wow-tbc \
  -DBUILD_EXTRACTORS=OFF \
  -DPCH=1 \
  -DDEBUG=0 \
  -DBUILD_AHBOT=ON \
  -DBUILD_PLAYERBOTS=OFF \
  -DBUILD_GIT_ID=ON

make -j7
make install
```

Danach können die geprüften Branches mit GitHub Desktop oder `git push origin <branchname>` hochgeladen werden.
