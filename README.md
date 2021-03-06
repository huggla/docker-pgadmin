**Note! I use Docker latest tag for development, which means that it isn't allways working. Date tags are stable.**

# pgadmin-alpine
Pgadmin 4 on Alpine. Note that pgAdmin will by default run in desktop mode (no multi-user and authentication).

## How to use it
```
docker run -d -p 5050:5050 --name pgadmin huggla/pgadmin
```
Then you can access pgAdmin at <http://localhost:5050>.

If you have a PostgreSQL instance running on the host and you want to connect the pgAdmin container to it, remember that you cannot use `localhost` in the Host field of pgAdmin's "Create server" dialog, because `localhost` there means *the container itself*. Use the host's IP instead, e.g. what you get from `` echo `ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1` ``.

pgAdmin's config, log, sessions and SQLite configuration database will be lost if you remove the container. To persist them, create a named volume and mount it to the config directory in the container, e.g.:
```
docker run -d -p 5050:5050 -v data:/etc/pgadmin --name pgadmin huggla/pgadmin-alpine
```
Now you can remove the container when you are done with it, and next time you need pgAdmin, you can start a new one with the same volume option (`-v data:/etc/pgadmin`) and everything will still be there (the servers you added etc.), assuming you did not remove the named volume.

## Pre-set environment variables (can be set at runtime)
* REV_CONFIG_FILE (/etc/pgadmin/config_local.py)
### Default Pgadmin configuration
* REV_param_DEFAULT_SERVER ('0.0.0.0')
* REV_param_SERVER_MODE (False)
* REV_param_ALLOW_SAVE_PASSWORD (False)
* REV_param_LOG_FILE ('/var/log/pgadmin4.log')
* REV_param_SQLITE_PATH ('/etc/pgadmin/pgadmin4.db')
* REV_param_SESSION_DB_PATH ('/etc/pgadmin/sessions')
* REV_param_STORAGE_DIR ('/etc/pgadmin/storage')
* REV_param_UPGRADE_CHECK_ENABLED (False)

## Optional environment variables
### Pgadmin configuration
* REV_param_&lt;parameter name&gt;

## Capabilities
Can drop all but CHOWN, FOWNER, SETGID and SETUID.

