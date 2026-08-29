# CMaNGOS TBC screen restarter

Copy both files to the server, adjust `cmangos-restarter.conf`, and make the
script executable:

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
