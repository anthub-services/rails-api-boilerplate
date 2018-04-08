# Rails API Boilerplate
This project is based on the
[Node API and Client Boilerplate](https://github.com/anthub-services/node-api-and-client-boilerplate).
Required Ruby version is `2.5.0`.
The API app is powered by [Ruby on Rails 5](http://rubyonrails.org/)
and used as API service for the [Create React App Boilerplate](https://github.com/anthub-services/create-react-app-boilerplate).

## Other API App Boilerplates

- [Node Express API Mockup Data Boilerplate](https://github.com/anthub-services/node-express-api-mockup-data-boilerplate) –
 non-database API server powered by [Express](https://expressjs.com/)
- [Node Express API Boilerplate](https://github.com/anthub-services/node-express-api-boilerplate) –
 API server powered by [Express](https://expressjs.com/) and [PostgreSQL](https://www.postgresql.org/) database

## Starting the App

Note: Only change the environment variables for `POSTGRES_USER` and `POSTGRES_PASSWORD` if working on local machine.

Copy `.env.local.dist` to `.env.local` and change the values of the environment variables if needed.

```
PORT=7770
ALLOW_ORIGIN=http://localhost:7771
JWT_SECRET=jwtsecretcode
RAILS_MAX_THREADS=5
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=rails_api_user
POSTGRES_PASSWORD=root
POSTGRES_DB=rails_api_dev
POSTGRES_DB_TEST=rails_api_test
```

Then run the following commands:

```
bundle
rails s
```

Note: The database must be created and initialized after starting the app on fresh installation.
See **Database using PostgreSQL and Sequelize** section. See **Bash Commands** section for Docker.

Access the app at <http://localhost:7770>.

## Docker

Download and install the [Docker Community Edition](https://www.docker.com/community-edition).

Note: See **Bash Commands** section for Docker.

## Database using PostgreSQL and Sequelize

**Installing PostgreSQL**

**Mac:** [Getting Started with PostgreSQL on Mac OSX](https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb)
<br>
**Windows:** [Installing PostgreSQL, Creating a User, and Creating a Database](https://confluence.atlassian.com/display/CONF30/Database+Setup+for+PostgreSQL+on+Windows)

NOTE: For Mac users, you can run the PostgreSQL server on a separate terminal console by running the following command:

```
postgres -D /usr/local/var/postgres
```

**Create and Initialize Database**

Open a terminal console and run the following commands:

```
rails db:migrate
rails db:seed
```

To drop database, run the following command:

```
rails db:drop
```

See **Bash Commands** section for Docker.

## Bash Commands

On the `root` directory of the project, run the following commands:

Note: To view the Docker containers, open another terminal console then enter `docker ps`.
To manage separate Docker instance for API, open another terminal console and run the commands below.

### Docker

| Command                                | Description                                                        |
|----------------------------------------|--------------------------------------------------------------------|
| `./bin/install`                        | Build the Docker containers, initialise database and start the app |
| `./bin/reinstall`                      | Re-build containers, re-initialise database and start the app      |
| `./bin/start`                          | Start all the services (API and database)                          |
| `./bin/stop`                           | Stop all the services                                              |
| `./bin/console <container ID or Name>` | Access the terminal console of the API container                   |

### Database

**Local**

| Command                               | Description                                                |
|---------------------------------------|------------------------------------------------------------|
| `./bin/pg/local/start`                | Start the PostgreSQL server (for Mac users only)           |
| `./bin/pg/local/resetdb`              | Drop and re-initialise database                            |
| `./bin/pg/local/migrate`              | Run new schema migration                                   |
| `./bin/pg/local/migrateundo <step>`   | Revert the recent schema migration                         |
| `./bin/pg/local/seed <seed file>`     | Run specific data seed file with or without .js extension  |
| `./bin/pg/local/seedundo <seed file>` | Revert the seed of specific data seed file                 |
| `./bin/pg/local/psql`                 | Access the database console                                |

**Docker**

- To run the commands for Docker database service, simply remove the `local` from the command
- The `start` command works only in local machine
- Used `./bin/pg/psql <database container ID or Name>` to access the database console

## Users

Use the following credentials to test different API responses. Default password for all accounts is `password`.

| Name              | Email                  | Description |
|-------------------|------------------------|-------------|
| Super Admin User  | `superadmin@email.com` | Has wildcard access |
| Admin User        | `admin@email.com`      | Has wildcard access but `Admin › Users › Delete` is excluded |
| Common User       | `user@email.com`       | Can access `My Profile`, `Admin › Dashboard`, `Users`, `Users › View, and Settings` |
| Referrer User     | `referrer@email.com`   | When `redirect` is set without the domain, e.i. `/admin/dashboard`, user shall be redirected to internal page if no location path (referrer) found on the Sign In page |
| Redirect User     | `redirect@email.com`   | When `redirect` is set with complete URL, e.i. `https://github.com/anthub-services`, user shall be redirected to external page if no location path (referrer) found on the Sign In page |
| Blocked User      | `blocked@email.com`    | User is signed in but the account is blocked |
| Unauthorized User | `<any invalid email>`  | Simply enter wrong `email` and/or `password` |

## Docker Boilerplates

The following boilerplates can be used to install and run the API and client boilerplates in a Docker container.

- [Docker for Node API Mockup Data and Client Boilerplates](https://github.com/anthub-services/docker-for-node-api-mockup-data-and-client-boilerplates)
- [Docker for Node API and Client Boilerplates](https://github.com/anthub-services/docker-for-node-api-and-client-boilerplates)
- [Docker for Rails API and Client Boilerplates](https://github.com/anthub-services/docker-for-rails-api-and-client-boilerplates)
