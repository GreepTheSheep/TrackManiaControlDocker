# TrackManiaControl Docker

This repository contains the Dockerfile and the entrypoint required to build a Docker Image of [Beu&#39;s TrackManiaControl](https://git.virtit.fr/beu/TrackManiaControl)

## Pulling this image

You can pull this image via GitHub registry (updated weekly if not disabled automatically, check build status in Actions tab):

```sh
docker pull ghcr.io/greepthesheep/trackmaniacontrol
```

## Environment variables

These variables are not required if you have already provided your `config/server.xml` file (see [Providing a config file](#providing-a-config-file))

| Variable name              | Required | Description                                                                                                       | Default      |
| -------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------- | ------------ |
| `SERVER_HOST`            | ✔️     | Trackmania server host                                                                                            |              |
| `SERVER_PORT`            |          | Trackmania server port                                                                                            | 5000         |
| `SERVER_SUPERADMIN_USER` |          | Trackmania username for the XML-RPC SuperAdmin access level                                                       | SuperAdmin   |
| `SERVER_SUPERADMIN_PASS` |          | Trackmania password for the XML-RPC SuperAdmin access level. It is required to change for security reasons       | SuperAdmin   |
| `DATABASE_HOST`          | ✔️     | MySQL (MariaDB) server hostname                                                                                   |              |
| `DATABASE_PORT`          |          | MySQL (MariaDB) server port                                                                                       | 3306         |
| `DATABASE_USER`          |          | MySQL (MariaDB) server user. It is required to change for security reasons                                        | maniacontrol |
| `DATABASE_PASS`          |          | MySQL (MariaDB) server password. It is required to change for security reasons                                    | maniacontrol |
| `DATABASE_NAME`          |          | MySQL (MariaDB) database name.                                                                                    | maniacontrol |
| `MASTERADMIN_LOGIN`      | ✔️     | Trackmania login for superadmin access. You can get your login via[Trackmania.io](https://trackmania.io/#/players) |              |

## Providing a config file

If you have already a `config/server.xml` file, you can provide using Docker volumes:

```sh
docker run -v ./myserver.xml:/controller/config/server.xml:ro git.greep.fr/greep/trackmaniacontrol
```

This will ignore environment variables.


## Docker compose example

This is a full Docker compose example to run a dedicated Trackmania server with [EvoTM's Trackmania image](https://hub.docker.com/r/evoesports/trackmania), MariaDB and this controller.

```yaml
services:
  mariadb:
    image: mariadb:lts
    container_name: trackmaniacontrol-db
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: maniacontrol-change-me
      MARIADB_DATABASE: trackmaniacontrol
      MARIADB_USER: maniacontrol
      MARIADB_PASSWORD: maniacontrol
    expose:
      - 3306
    volumes:
      - TrackManiaControl:/var/lib/mysql

  trackmania:
    image: evoesports/trackmania
    container_name: trackmaniacontrol-server
    environment:
      TM_SYSTEM_XMLRPC_ALLOWREMOTE: "True"
    expose:
      - 5001
    ports:
      - 2351:2350/tcp
      - 2351:2350/udp
    volumes:
      - TrackManiaUserData:/server/UserData

  trackmaniacontrol:
    image: ghcr.io/greepthesheep/trackmaniacontrol
    container_name: trackmaniacontrol-controller
    environment:
      SERVER_HOST: trackmania
      SERVER_PORT: "5001"
      DATABASE_HOST: mariadb
      DATABASE_USER: maniacontrol
      DATABASE_PASS: maniacontrol
      DATABASE_NAME: trackmaniacontrol
      MASTERADMIN_LOGIN: Jtmn3kBnSSadky_mLNhp_A
    # Uncomment this if you have already a server.xml file
    #volumes:
      #- ./myserver.xml:/controller/config/server.xml:ro

volumes:
  TrackManiaControl:
  TrackManiaUserData:
```