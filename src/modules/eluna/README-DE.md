# Eluna-Modul fuer CMaNGOS TBC – Integrationskandidat 1.0.0

## Status und Kompatibilitaet
Dieses Paket ergaenzt Eluna als optionales CMake-Laufzeitmodul. Die notwendigen
C++-Hooks sind im beiliegenden Core-Patch enthalten. Es ist kein DLL-Plugin und
kann nicht allein durch Kopieren eines Lua-Ordners installiert werden.

Gepruefte Patch-Basis:
- Repository: https://github.com/matuph/mangos-tbc
- Branch zum Analysezeitpunkt: feature/playertreff
- Commit: eb267eefca5b3dfcbdc69df68849612174f461f0

Andere Nutzer koennen dieselbe Basis verwenden. Andere CMaNGOS-Staende sowie
TrinityCore, AzerothCore und MaNGOS One sind nicht als kompatibel bestaetigt.
Der Installer verweigert abweichende Commits, lokale Aenderungen und offene Merges.

Quellen:
- Core-Integration: https://github.com/Eluna-Ports/Eluna-CMaNGOS-TBC
  Stand 57b0aeb5b1b9a065e0dfe65853a9f36a7a01d0a8 (2026-09-29).
- Engine: https://github.com/ElunaLuaEngine/Eluna
  Fixierter Stand 1b06f28ff3a00054d915d824c725fb4283fee74d (2026-06-28),
  entsprechend der Referenz des TBC-Forks. Kein ungeprueftes Engine-Update auf master.
- Lua: Standard des Forks, Lua 5.2.4; Auswahl ueber LUA_VERSION.
  Dieses Paket behauptet kein Update auf die neueste Lua-Hauptversion.

## Windows-Installation
ZIP in einen eigenen Ordner entpacken. PowerShell dort oeffnen.
Zuerst nur pruefen:

    powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Eluna.ps1 -Repository 'G:\source_\matuph\mangos-tbc' -CheckOnly

Danach installieren:

    powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Eluna.ps1 -Repository 'G:\source_\matuph\mangos-tbc'

Der Installer erzeugt einen neuen lokalen Branch, wendet den Patch an, installiert
die fixierte Engine aus dem mitgelieferten Git-Bundle und erstellt einen Commit.
Eine Git-Identitaet muss vorhanden sein. Der bisherige Branch bleibt erhalten.
Es erfolgen kein Push, SQL-Import oder Serverstart. Kein automatischer Build.
Bei Fehlern bleibt der neue Branch zur Untersuchung bestehen.

## Build
Visual Studio 2022 mit C++- und Windows-SDK-Komponenten, CMake sowie die normalen
CMaNGOS-Abhaengigkeiten (u.a. Boost/MySQL/OpenSSL) werden benoetigt.
In einer Entwicklerkonsole im gepatchten Repository:

    cmake -S . -B build-eluna -DBUILD_MODULE_ELUNA=ON -DLUA_VERSION=lua52
    cmake --build build-eluna --config Release --parallel

Fuer die vorhandenen Zusatzmodule bei der Konfiguration ergaenzen:

    -DBUILD_MODULES=ON -DBUILD_MODULE_PLAYERTREFF=ON -DBUILD_MODULE_LEVEL58UPGRADE=ON

BUILD_ELUNA=ON bleibt als kompatibler Schalter verfuegbar. Zum Abschalten beide
Eluna-Schalter auf OFF setzen und Eluna-abhaengige Zusatzmodule deaktivieren.
Eluna wird nicht in modules.conf registriert: Es ist eine Core-Erweiterung mit
eigener Lebensdauer, kein ueber AddModules erzeugter ModuleMgr-Handler.

## Laufzeit
Neue Eluna-Einstellungen aus src/mangosd/mangosd.conf.dist.in gezielt in die
bestehende Serverkonfiguration uebernehmen. Mindestens:

    Eluna.Enabled = 1
    Eluna.ScriptPath = "lua_scripts"

Server neu bauen und mit den neuen Binaerdateien starten. Eigene Lua-Dateien in
den konfigurierten Skriptordner kopieren. Das Testskript liegt unter
src/modules/eluna/lua_scripts/eluna_module_check.lua; CMake installiert es beim
Installationsschritt ebenfalls. Nach dem Laden erscheint:

    [Eluna module] Lua scripts loaded; runtime: Lua 5.2

Playertreff- und Level58Upgrade-SQL bleiben eigenstaendige Modulvoraussetzungen.
Dieser Patch enthaelt keine SQL-Aenderungen und behebt keinen offenen tbc-db-Merge.

## Manuell / Linux
Auf der genannten sauberen Basis einen neuen Branch anlegen, dann:

    git apply --check /pfad/eluna-core.patch
    git apply --index /pfad/eluna-core.patch
    git clone /pfad/eluna-engine.bundle src/game/LuaEngine
    git -C src/game/LuaEngine checkout --detach 1b06f28ff3a00054d915d824c725fb4283fee74d
    git -C src/game/LuaEngine remote set-url origin https://github.com/ElunaLuaEngine/Eluna.git
    git commit -m "Add optional Eluna runtime module and core hooks"

Alternativ zur Bundle-Kopie: git submodule update --init --recursive.
Engine und Core-Hooks immer gemeinsam auf Kompatibilitaet pruefen.

## Pruefung und Grenzen
- Acht Konfliktdateien zwischen ModuleMgr und Eluna manuell zusammengefuehrt.
- Vorhandene ModuleMgr-Aufrufe beibehalten; doppelte ModifyMoney-Funktion vereint.
- Einheitliche Eluna-Definitionen fuer Core und Zusatzmodule ueber CMake-Interface.
- Lua-Download bei abgeschaltetem Eluna deaktiviert.
- Unabhaengige SoloCraft-Erweiterung und CI-Aenderungen des Forks nicht uebernommen.
- Kein vollstaendig erfolgreicher C++-Build und kein Server-Laufzeittest.
  Die Konfiguration wurde durch Windows-SDK-Zugriffsrechte blockiert.
Das Paket ist deshalb ein Integrationskandidat, keine freigegebene Server-Binaerdatei.
Weitere tatsaechlich ausgefuehrte Paketpruefungen stehen in VALIDATION.txt.

## Lizenzen
Core: siehe COPYING/README und COPYRIGHT des Ziel-Repositories.
Eluna: GPLv3, vollstaendiger Quellstand mit Lizenz im eluna-engine.bundle.
Lua wird beim Build aus den in dep/lualib/lua/CMakeLists.txt festgelegten Quellen
mit SHA256-Pruefung geladen. Lizenzen und Copyright-Hinweise der Projekte erhalten.