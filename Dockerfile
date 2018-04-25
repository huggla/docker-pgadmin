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

 \
    PACKAGE_DIR="/usr/lib/python2.7/site-packages/pgadmin4"
ENV REV_CONFIG_FILE="$CONFIG_DIR/config_local.py \
    REV_LINUX_USER="postgres"

ENV REV_LINUX_USER="postgres" \
    REV_HOSTADDR="localhost" \
    REV_DBNAME="postgres" \
    REV_USER="postgres"

USER pgadmin

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["python ${PACKAGE_DIR}/pgAdmin4.py"]
