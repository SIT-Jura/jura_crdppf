FROM camptocamp/c2cwsgiutils:5
LABEL maintainer "info@camptocamp.org"

WORKDIR /app

ARG PYTHON_DEV_PACKAGES="python3.8-dev build-essential"
ARG DEV_PACKAGES="libgeos-c1v5 libpq-dev libgeos-dev"

RUN mkdir /var/log/host_apache_logs

COPY requirements.txt /app/

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
        ${PYTHON_DEV_PACKAGES} ${DEV_PACKAGES} && \
    apt install --yes vim && \
    pip3 install --disable-pip-version-check --no-cache-dir --requirement requirements.txt && \
    apt-get clean && \
    rm --force --recursive /var/lib/apt/lists/*

COPY . /app

COPY production.ini .
COPY jura_crdppf ./jura_crdppf
COPY setup.py .
COPY scripts ./scripts
COPY config.yaml .
COPY config-for-scripts.yaml .

RUN pip3 install --disable-pip-version-check --no-cache-dir --editable .

RUN apt remove --purge --autoremove --yes ${PYTHON_DEV_PACKAGES} binutils
