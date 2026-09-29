# BlogServer

A Docker-based multi-service blog infrastructure project that combines a
user service, MySQL database, and Nginx web server.

The project is designed to provide a simple service-oriented environment
for managing users, storing blog data, and serving user-specific static
blog content through Nginx.

## Overview

BlogServer separates its main responsibilities into independent Docker
services:

-   **User Service** --- provides the user-side environment and database
    access.
-   **MySQL Service** --- stores persistent application and blog data.
-   **Nginx Service** --- serves static/blog content and supports
    username-based blog paths.

All services are orchestrated with Docker Compose.

## Architecture

``` text
                              ┌──────────────────────┐
                              │        Client        │
                              └──────────┬───────────┘
                                         │
                                         │ HTTP :5001
                                         ▼
                              ┌──────────────────────┐
                              │    Nginx Service     │
                              │                      │
                              │  Static Blog Files   │
                              │  <username>.blog.in  │
                              └──────────────────────┘


                              ┌──────────────────────┐
                              │    User Service      │
                              │                      │
                              │     Ubuntu 20.04     │
                              │     Bash / yq        │
                              │     MySQL Client     │
                              └──────────┬───────────┘
                                         │
                                         │ MySQL
                                         ▼
                              ┌──────────────────────┐
                              │    MySQL Service     │
                              │                      │
                              │      MySQL 8.0       │
                              │        mydb          │
                              └──────────────────────┘
```

## Features

-   Docker Compose-based service orchestration
-   Separate user, database, and web-server services
-   MySQL 8.0 database
-   Nginx static content serving
-   Persistent MySQL data
-   Persistent blog/static content
-   Username-based blog hosting structure
-   Local development environment
-   Bash-based user-service container
-   MySQL client and `yq` utilities inside the user-service image

## Project Structure

``` text
BlogServer/
│
├── config/
│   └── Configuration files
│
├── mysql-service/
│   ├── data/
│   └── init.sql
│
├── nginx-service/
│   ├── Dockerfile
│   └── nginx.conf
│
├── scripts/
│   └── Utility/setup scripts
│
├── user-service/
│   └── Dockerfile
│
├── data/
│   └── authors/
│       └── <username>/
│           └── public/
│
├── docker-compose.yml
└── README.md
```

## Technologies

  Technology       Purpose
  ---------------- ---------------------------
  Docker           Containerization
  Docker Compose   Service orchestration
  MySQL 8.0        Database
  Nginx            Web/static content server
  Ubuntu 20.04     User-service base image
  Bash             Shell and scripting
  MySQL Client     Database administration
  yq               YAML processing

## Prerequisites

Install the following before running the project:

-   Docker
-   Docker Compose

Verify your installation:

``` bash
docker --version
docker compose version
```

## Getting Started

### 1. Clone the repository

``` bash
git clone https://github.com/ankushkumar227/BlogServer.git
cd BlogServer
```

### 2. Build and start the services

``` bash
docker compose up --build
```

To run the services in the background:

``` bash
docker compose up --build -d
```

### 3. Check the running containers

``` bash
docker compose ps
```

### 4. View logs

``` bash
docker compose logs
```

To follow logs continuously:

``` bash
docker compose logs -f
```

## Services

### User Service

The user service is built from:

``` text
./user-service
```

The image is based on Ubuntu 20.04 and provides a shell environment with
utilities used by the project, including Bash, the MySQL client, and
`yq`.

The service has access to:

``` text
./scripts  → /scripts
./config   → /config
./data     → /home
```

The current Compose configuration starts this container with Bash:

``` yaml
command: bash
```

You can open a shell inside it with:

``` bash
docker exec -it user-service bash
```

### MySQL Service

The database service uses:

``` text
mysql:8.0
```

The default development database is:

``` text
Database: mydb
```

MySQL uses port `3306` inside the container and is mapped to port `3307`
on the host:

``` text
localhost:3307 → mysql:3306
```

Database persistence is provided through:

``` text
./mysql-service/data:/var/lib/mysql
```

The initialization script is mounted at:

``` text
./mysql-service/init.sql:/docker-entrypoint-initdb.d/init.sql
```

This allows the database schema and initial configuration to be created
when the database is initialized.

### Nginx Service

The Nginx service is built from:

``` text
./nginx-service
```

It maps:

``` text
localhost:5001 → Nginx:80
```

Static/blog content is mounted into:

``` text
/usr/share/nginx/html
```

from:

``` text
./data/authors
```

The intended blog structure is:

``` text
data/
└── authors/
    ├── alice/
    │   └── public/
    └── bob/
        └── public/
```

The Nginx configuration supports username-based hostnames following the
pattern:

``` text
<username>.blog.in
```

For example:

``` text
alice.blog.in
bob.blog.in
```

The corresponding public files are served from:

``` text
/usr/share/nginx/html/alice/public
/usr/share/nginx/html/bob/public
```

For local testing, you may need to configure your hosts file or local
DNS so that the desired hostname resolves to `127.0.0.1`.

## Database Schema

The initialization script creates the `mydb` database.

### Users

The `users` table contains:

  Column         Type             Description
  -------------- ---------------- ----------------------------
  `id`           `VARCHAR(100)`   User identifier
  `role`         `ENUM`           User role
  `created_on`   `DATETIME`       Account creation timestamp

Supported roles include:

``` text
user
author
mod
admin
```

### Blogs

The `blogs` table contains:

  Column        Type             Description
  ------------- ---------------- -----------------
  `id`          `VARCHAR(100)`   Blog identifier
  `blog_name`   `VARCHAR(255)`   Blog name
  `status`      `VARCHAR(20)`    Blog status

The schema is initialized by:

``` text
mysql-service/init.sql
```

## Accessing MySQL

Once the containers are running, connect to the MySQL instance from the
host:

``` bash
mysql -h 127.0.0.1 -P 3307 -u <application-user> -p
```

Then select the database:

``` sql
USE mydb;
```

List the available tables:

``` sql
SHOW TABLES;
```

Do not place real production credentials directly in this README or in
`docker-compose.yml`.

## Accessing the Nginx Server

Start the stack and open:

``` text
http://localhost:5001
```

For username-based blog hosting, configure a local hostname such as:

``` text
alice.blog.in
```

to resolve to:

``` text
127.0.0.1
```

Then place the corresponding website files under:

``` text
data/authors/alice/public/
```

## Docker Commands

Start the application:

``` bash
docker compose up
```

Start in detached mode:

``` bash
docker compose up -d
```

Build the images:

``` bash
docker compose build
```

Build and start:

``` bash
docker compose up --build
```

Stop the application:

``` bash
docker compose down
```

Stop the application and remove volumes:

``` bash
docker compose down -v
```

> Warning: `docker compose down -v` can remove persisted database data.

Check running containers:

``` bash
docker compose ps
```

View all logs:

``` bash
docker compose logs -f
```

View a specific service:

``` bash
docker compose logs user-service
docker compose logs mysql-services
docker compose logs nginx-service
```

Open a shell inside the user service:

``` bash
docker exec -it user-service bash
```

Open a MySQL shell:

``` bash
docker exec -it mysql-service mysql -uroot -p
```

## Data Persistence

The project uses bind mounts for persistent data.

### MySQL data

``` text
./mysql-service/data
```

### Blog/static content

``` text
./data/authors
```

The project also mounts configuration and scripts into the user service:

``` text
./scripts
./config
./data
```

## Troubleshooting

### MySQL does not initialize

If MySQL has already been initialized, changes to `init.sql` may not be
applied because the existing database files are preserved.

For a clean development reset:

``` bash
docker compose down -v
docker compose up --build
```

Use this carefully because removing volumes can delete locally persisted
database data.

### Check service status

``` bash
docker compose ps
```

### Check MySQL logs

``` bash
docker compose logs mysql-services
```

### Check Nginx logs

``` bash
docker compose logs nginx-service
```

### Check user-service logs

``` bash
docker compose logs user-service
```

## Security

This repository is intended primarily as a development/project
environment.

Before deploying it publicly:

1.  Move database credentials to environment variables or Docker
    secrets.
2.  Rotate any credentials that have already been committed to a public
    repository.
3.  Do not commit passwords, API keys, or other secrets to Git.
4.  Restrict database access to trusted hosts.
5.  Review whether Nginx directory listing should be enabled.
6.  Add authentication and authorization where required.
7.  Add health checks and appropriate restart policies.
8.  Avoid running application processes as root where possible.
9.  Use separate production configuration rather than development
    defaults.

## Development Workflow

Clone the project:

``` bash
git clone https://github.com/ankushkumar227/BlogServer.git
cd BlogServer
```

Start the development environment:

``` bash
docker compose up --build
```

Make changes to the relevant service, rebuild the affected image, and
restart the Compose stack.

## Future Improvements

Potential improvements include:

-   Add automated tests.
-   Add Docker health checks.
-   Add CI/CD with GitHub Actions.
-   Move all secrets to environment variables or Docker secrets.
-   Add explicit restart policies.
-   Add API documentation if HTTP endpoints are introduced.
-   Add production-specific Docker Compose configuration.
-   Add structured logging and monitoring.
-   Add a documented local DNS/hosts-file setup.
-   Add authentication and authorization.
-   Add container security hardening.
-   Add a dedicated application entrypoint for the user service.

## License

No license file is currently documented for this repository. If you
intend to distribute BlogServer as open-source software, add an
appropriate `LICENSE` file.

## Author

**Ankush Kumar**

GitHub: [ankushkumar227](https://github.com/ankushkumar227)

## Repository

[BlogServer](https://github.com/ankushkumar227/BlogServer)
