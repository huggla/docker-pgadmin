FROM huggla/alpine

COPY ./bin ${BIN_DIR}

ENV PGADMIN4_VERSION="2.0" \
    CONFIG_DIR="/etc/pgadmin" \
    REV_LINUX_USER="postgres" \
    REV_PACKAGE_DIR="/usr/lib/python2.7/site-packages/pgadmin4"

RUN apk --no-cache add python postgresql-libs \
 && apk --no-cache add --virtual .build-dependencies python-dev py-pip gcc musl-dev postgresql-dev wget ca-certificates \
 && wget -q https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN4_VERSION}/pip/pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && pip install --upgrade pip \
 && pip --no-cache-dir install pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && rm pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && apk del .build-dependencies \
 && mkdir -p /var/lib/pgadmin \
 && ln /usr/bin/python2.7 "$BIN_DIR/python"

ENV REV_CONFIG_FILE="$CONFIG_DIR/config_local.py" \
    REV_param_DEFAULT_SERVER="'0.0.0.0'" \
    REV_param_SERVER_MODE="False" \
    REV_param_ALLOW_SAVE_PASSWORD="False" \
    REV_param_CONSOLE_LOG_LEVEL="logging.WARNING" \
    REV_param_FILE_LOG_LEVEL="logging.NOTSET" \
    REV_param_SQLITE_PATH="'$CONFIG_DIR/pgadmin4.db'" \
    REV_param_SESSION_DB_PATH="'$CONFIG_DIR/sessions'" \
    REV_param_STORAGE_DIR="'$CONFIG_DIR/storage'" \
    REV_param_UPGRADE_CHECK_ENABLED="False"

USER sudoer
