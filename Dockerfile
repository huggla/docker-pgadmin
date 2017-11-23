FROM alpine:3.6

ENV PGADMIN4_VERSION 2.0

RUN apk --no-cache add python postgresql-libs && \
    apk --no-cache add --virtual build-dependencies python-dev py-pip gcc musl-dev postgresql-dev wget ca-certificates && \
    wget -q https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN4_VERSION}/pip/pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl && \
    pip --no-cache-dir install pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl && \
    rm pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl && \
    apk del build-dependencies    

ENV PACKAGE_DIR /usr/lib/python2.7/site-packages/pgadmin4
ENV PGADMIN4_DIR /pgadmin4
ENV CONFIG_FILE $PGADMIN4_DIR/config_local.py

VOLUME $PGADMIN4_DIR

RUN mkdir $PGADMIN4_DIR /var/lib/pgadmin && \
    echo "DEFAULT_SERVER = '0.0.0.0'" > $CONFIG_FILE && \
    echo "LOG_FILE = '$PGADMIN4_DIR/pgadmin4.log'" >> $CONFIG_FILE && \
    echo "SQLITE_PATH = '$PGADMIN4_DIR/pgadmin4.db'" >> $CONFIG_FILE && \
    echo "SESSION_DB_PATH = '$PGADMIN4_DIR/sessions'" >> $CONFIG_FILE && \
    echo "STORAGE_DIR = '$PGADMIN4_DIR/storage'" >> $CONFIG_FILE && \
    ln -fs $CONFIG_FILE $PACKAGE_DIR/ && \
    adduser -D -h $PGADMIN4_DIR pgadmin && \
    chown -R pgadmin:pgadmin $PGADMIN4_DIR /var/lib/pgadmin

USER pgadmin



EXPOSE 5050

CMD ["sh", "-c", "python ${PACKAGE_DIR}/pgAdmin4.py"]
