# LAPPd - Linux Apache PHP PostgreSQL on Docker

Docker Compose for Apache, PostgreSQL, PHP.

## Project Goals

The goal is to have a stable, simple, reasonably lightweight, ready-to-use
platform to run simple PHP applications using PostgreSQL.

## Maturity

This project is in Beta stage.

If you use it, please report any bug you may found.
If you use it in production, please inform the maintainer so he knows that the 
project is being used.
Any feedback is welcome.

To contact the maintainer, see the **Maintainer** section below.

## Requirements

- Docker;
- Docker Compose, any version able to parse file format version 2.

## Setup

Create `.env` file from `.env.default`:

```
cp .env.default .env
```

Edit `.env`, especially the PostgreSQL credentials you want to create.
Be sure to change the line which sets `$CUSTOM_CONFIG`, to confirm that the configuration
has been edited. Otherwise `up.sh` will refuse to create the containers.

To create the containers, run:

```
cd /path/to/project
./up.sh
```

To recreate the containers in case they are already there:

```
cd /path/to/project
FORCE=1 ./up.sh
```

Once the containers are up and running, any standard Docker Compose command
will work.

## License

Copyright 2019, Federico Razzoli

```
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

## Maintainer

Federico Razzoli
- Email: <hello@federico-razzoli.com>
- Website: https://federico-razzoli.com


