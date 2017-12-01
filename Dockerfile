FROM alpine:3.6

ENV PGADMIN4_VERSION 2.0

RUN apk --no-cache add python postgresql-libs \
 && apk --no-cache add --virtual build-dependencies python-dev py-pip gcc musl-dev postgresql-dev wget ca-certificates \
 && wget -q https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN4_VERSION}/pip/pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && pip --no-cache-dir install pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && rm pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl \
 && apk del build-dependencies    

ENV PACKAGE_DIR /usr/lib/python2.7/site-packages/pgadmin4
ENV PGADMIN4_DIR /pgadmin4
ENV CONFIG_FILE $PACKAGE_DIR/config_local.py

RUN mkdir /var/lib/pgadmin \
 && echo "DEFAULT_SERVER = '0.0.0.0'" > $CONFIG_FILE \
 && echo "SERVER_MODE = False" >> $CONFIG_FILE \
 && echo "ALLOW_SAVE_PASSWORD = False" >> $CONFIG_FILE \
 && echo "LOG_FILE = '$PGADMIN4_DIR/pgadmin4.log'" >> $CONFIG_FILE \
 && echo "SQLITE_PATH = '$PGADMIN4_DIR/pgadmin4.db'" >> $CONFIG_FILE \
 && echo "SESSION_DB_PATH = '$PGADMIN4_DIR/sessions'" >> $CONFIG_FILE \
 && echo "STORAGE_DIR = '$PGADMIN4_DIR/storage'" >> $CONFIG_FILE \
 && echo "UPGRADE_CHECK_ENABLED = False" >> $CONFIG_FILE \
 && adduser -D -h $PGADMIN4_DIR pgadmin \
 && cp $CONFIG_FILE $PGADMIN4_DIR/config_local.py \
 && ln -fs $PGADMIN4_DIR/config_local.py $CONFIG_FILE \
 && chown -R pgadmin:pgadmin $PGADMIN4_DIR $PACKAGE_DIR

USER pgadmin

VOLUME $PGADMIN4_DIR

EXPOSE 5050

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["python ${PACKAGE_DIR}/pgAdmin4.py"]
