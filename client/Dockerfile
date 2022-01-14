FROM python:3.9-slim
ARG PIP_OPTIONS=
#ARG PIP_OPTIONS="--trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple"

COPY . /app

WORKDIR /app

RUN /usr/local/bin/python3 -m pip install --upgrade pip
RUN pip install ${PIP_OPTIONS} --requirement requirements.txt \
    gunicorn PasteDeploy
RUN pip install .

CMD ["/app/docker-entrypoint.sh"]
