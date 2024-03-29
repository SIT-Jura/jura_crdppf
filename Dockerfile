FROM python:3.9-slim
LABEL maintainer "info@camptocamp.org"
ARG PYTHON_DEV_PACKAGES="build-essential"
ARG DEV_PACKAGES="libgeos-c1v5 libpq-dev libgeos-dev"
ARG PIP_OPTIONS=
# If you need to use a test package, use this PIP_OPTIONS instead:
#ARG PIP_OPTIONS="--trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple"

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
        ${PYTHON_DEV_PACKAGES} ${DEV_PACKAGES} && \
    apt-get clean && \
    rm --force --recursive /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt /app/

RUN pip3 install ${PIP_OPTIONS} --disable-pip-version-check --no-cache-dir \
    --requirement requirements.txt \
    gunicorn PasteDeploy

COPY . .

RUN pip3 install ${PIP_OPTIONS} --disable-pip-version-check --no-cache-dir -e .
EXPOSE 8080
CMD ["gunicorn", "--paste", "production.ini", "--forwarded-allow-ips", "*", "-b 0.0.0.0:8080", "--worker-class", "gthread", "--threads", "10", "--workers", "1", "--timeout", "60", "--max-requests", "1000", "max-requests-jitter", "100", "--worker-tmp-dir", "/dev/shm", "--limit-request-line", "8190"]
