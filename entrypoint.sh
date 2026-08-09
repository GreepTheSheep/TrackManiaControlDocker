#!/bin/sh

echo "* Beu's TrackMania Control Docker Image"
echo "* Directory: $(pwd)"

if [[ ! -e configs/server.xml ]]; then
    echo "* Config file does not exist. Creating one using environment variables"

    if [[ -z "${SERVER_HOST}" ]]; then
        echo "* SERVER_HOST required environment variable isn't defined."
        exit 1
    fi
    if [[ -z "${DATABASE_HOST}" ]]; then
        echo "* DATABASE_HOST required environment variable isn't defined."
        exit 1
    fi
    if [[ -z "${MASTERADMIN_LOGIN}" ]]; then
        echo "* MASTERADMIN_LOGIN required environment variable isn't defined."
        exit 1
    fi

    xmlstarlet ed \
    -u '/maniacontrol/server/host' -v "${SERVER_HOST}" \
    -u '/maniacontrol/server/port' -v "${SERVER_PORT:-5000}" \
    -u '/maniacontrol/server/user' -v "${SERVER_SUPERADMIN_USER:-SuperAdmin}" \
    -u '/maniacontrol/server/pass' -v "${SERVER_SUPERADMIN_PASS:-SuperAdmin}" \
    -u '/maniacontrol/database/host' -v "${DATABASE_HOST}" \
    -u '/maniacontrol/database/port' -v "${DATABASE_PORT:-3306}" \
    -u '/maniacontrol/database/user' -v "${DATABASE_USER:-maniacontrol}" \
    -u '/maniacontrol/database/pass' -v "${DATABASE_PASS:-maniacontrol}" \
    -u '/maniacontrol/database/name' -v "${DATABASE_NAME:-maniacontrol}" \
    -u '/maniacontrol/masteradmins/login' -v "${MASTERADMIN_LOGIN}" \
    < configs/server.default.xml > configs/server.xml
else
    echo "* Config file exists, using existing one"
fi

echo "* Running TrackManiaControl"
php ManiaControl.php