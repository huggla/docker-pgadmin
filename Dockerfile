FROM alpine:3.6

ENV PGADMIN4_VERSION 2.0

RUN apk --no-cache add python postgresql-libs && \
    apk --no-cache add --virtual build-dependencies python-dev py-pip gcc musl-dev postgresql-dev wget ca-certificates && \
    wget -q https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN4_VERSION}/pip/pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl && \
    pip --no-cache-dir install pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl && \
    rm pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl && \
    apk del build-dependencies

ENV PACKAGE_DIR /usr/lib/python2.7/site-packages/pgadmin4
ENV CONFIG_FILE $PACKAGE_DIR/config_local.py

RUN echo "DEFAULT_SERVER = '0.0.0.0'" > $CONFIG_FILE && \
    echo "LOG_FILE = '/pgadmin/pgadmin.log'" >> $CONFIG_FILE && \
    echo "SQLITE_PATH = '/pgadmin/sqlite'" >> $CONFIG_FILE && \
    echo "SESSION_DB_PATH = '/pgadmin/sessions'" >> $CONFIG_FILE && \
    echo "STORAGE_DIR = '/pgadmin'" >> $CONFIG_FILE && \
    adduser -D pgadmin && \
    mkdir /pgadmin /pgadmin/sqlite /pgadmin/sessions && \
    chown -R pgadmin:pgadmin /pgadmin

USER pgadmin

VOLUME /home/pgadmin

EXPOSE 5050

CMD ["sh", "-c", "python ${PACKAGE_DIR}/pgAdmin4.py"]
