FROM huggla/alpine

ENV PGADMIN4_VERSION="2.0" \
    CONFIG_DIR="/etc/pgadmin"

RUN apk --no-cache add python postgresql-libs \
 && apk --no-cache add --virtual .build-dependencies python-dev py-pip gcc musl-dev postgresql-dev wget ca-certificates \
 && wget -q https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN4_VERSION}/pip/pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && pip --no-cache-dir install pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && rm pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && apk del .build-dependencies \
 && mkdir -p /var/lib/pgadmin

ENV REV_PACKAGE_DIR="/usr/lib/python2.7/site-packages/pgadmin4" \
    REV_CONFIG_FILE="$CONFIG_DIR/config_local.py \
    REV_LINUX_USER="postgres" \
    REV_param_DEFAULT_SERVER="'0.0.0.0'" \
    REV_param_SERVER_MODE="False" \
    REV_param_ALLOW_SAVE_PASSWORD="False" \
    REV_param_LOG_FILE="'/var/log/pgadmin4.log'" \
    REV_param_SQLITE_PATH="'$CONFIG_DIR/pgadmin4.db'" \
    REV_param_SESSION_DB_PATH="'$CONFIG_DIR/sessions'" \
    REV_param_STORAGE_DIR="'$CONFIG_DIR/storage'" \
    REV_param_UPGRADE_CHECK_ENABLED="False"

USER sudoer
