**Note! I use Docker latest tag for development, which means that it isn't allways working. Date tags are stable.**

# pgadmin-alpine
Note that pgAdmin will by default run in desktop mode (no multi-user and authentication).

## How to use it
```
docker run -d -p 5050:5050 --name pgadmin huggla/pgadmin
```
Then you can access pgAdmin at <http://localhost:5050>.

If you have a PostgreSQL instance running on the host and you want to connect the pgAdmin container to it, remember that you cannot use `localhost` in the Host field of pgAdmin's "Create server" dialog, because `localhost` there means *the container itself*. Use the host's IP instead, e.g. what you get from `` echo `ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1` ``.

pgAdmin's config, log, sessions and SQLite configuration database will be lost if you remove the container. To persist them, create a named volume and mount it to `/pgadmin4` in the container, e.g.:
```
docker run -d -p 5050:5050 -v data:/pgadmin4 --name pgadmin huggla/pgadmin-alpine
```
Now you can remove the container when you are done with it, and next time you need pgAdmin, you can start a new one with the same volume option (`-v data:/pgadmin4`) and everything will still be there (the servers you added etc.), assuming you did not remove the named volume.

## Pre-set environment variables (can be set at runtime)
* REV_DATABASES (*=port=5432): Comma separated list of backend databases. Default set to only read from Unix socket.
### Default Pgbouncer configuration
* REV_param_auth_file (/etc/pgbouncer/userlist.txt): Pgbouncer authentication file.
* REV_param_auth_hba_file (/etc/pgbouncer/pg_hba.conf): Pgbouncer hba authentication file.
* REV_param_unix_socket_dir (/run/pgbouncer): Pgbouncer Unix socket dir, used by both frontend and backend.
* REV_param_listen_addr (*): Allowed client network addresses. Default set to allow all.

## Runtime environment variables
* REV_DATABASE_USERS: Comma separated list of database users.
* REV_AUTH_HBA: Comma separated list of hba rules. Optional.
### Pgbouncer configuration
* REV_param_&lt;parameter name&gt;: f ex param_auth_type.
### Database user configuration
* REV_password&#95;file_&lt;user name from DATABASE_USERS&gt;: Path to file containing the password for named user. **Note! This file will be deleted unless write protected.**
* REV_password_&lt;user name from DATABASE_USERS&gt;: The password for named user. Slightly less secure.

## Capabilities
Can drop all but CHOWN, FOWNER, SETGID and SETUID.

