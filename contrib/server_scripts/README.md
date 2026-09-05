# CMaNGOS TBC screen restarter

Install the restarter for the default server path:

    chmod +x install-restarter.sh
    ./install-restarter.sh

For a different installation prefix, pass it as the first argument:

    ./install-restarter.sh /srv/cmangos-tbc

Then adjust the installed `bin/cmangos-restarter.conf` if required. The manual
alternative is to copy `cmangos-restarter.sh` and `cmangos-restarter.conf` into
the same directory and make the script executable:

    chmod +x cmangos-restarter.sh
    sudo apt install screen gdb

Common commands:

    ./cmangos-restarter.sh start
    ./cmangos-restarter.sh stop
    ./cmangos-restarter.sh restart
    ./cmangos-restarter.sh status
    ./cmangos-restarter.sh logs
    ./cmangos-restarter.sh wmonitor

Normal program output is appended to `mangosd.log` and `realmd.log`.
Supervisor events are written to `restarter.log`. With
`DEBUG_WITH_GDB=true` or `wdstart`, timestamped GDB reports are stored below
`logs/restarter/crashes`.

The stop command removes the supervisor marker before sending `saveall` and a
graceful world shutdown. Therefore an intentional stop does not trigger an
automatic restart. If shutdown exceeds `SHUTDOWN_WAIT`, only the matching
screen session is closed; the script never uses a global `killall -9`.
