[1mdiff --git a/Dockerfile b/Dockerfile[m
[1mindex 2f16f4a..fc2a21a 100644[m
[1m--- a/Dockerfile[m
[1m+++ b/Dockerfile[m
[36m@@ -4,7 +4,7 @@[m [mARG PYTHON_DEV_PACKAGES="build-essential"[m
 ARG DEV_PACKAGES="libgeos-c1v5 libpq-dev libgeos-dev"[m
 ARG PIP_OPTIONS=[m
 # If you need to use a test package, use this PIP_OPTIONS instead:[m
[31m-#ARG PIP_OPTIONS="--trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple"[m
[32m+[m[32mARG PIP_OPTIONS="--trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple"[m
 [m
 RUN apt update && \[m
     DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \[m
[1mdiff --git a/Makefile b/Makefile[m
[1mindex 201985d..2972434 100644[m
[1m--- a/Makefile[m
[1m+++ b/Makefile[m
[36m@@ -1,7 +1,7 @@[m
 PYTHON_VERSION ?= python3.7[m
 VENV_BIN ?= .venv/bin/[m
 PIP_UPDATE = $(VENV_BIN)pip3 install --upgrade pip[m
[31m-#PIP_OPTIONS ?= --trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple[m
[32m+[m[32mPIP_OPTIONS ?= --trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple[m
 PIP_CMD ?= $(VENV_BIN)pip3 install ${PIP_OPTIONS} docker-compose flake8[m
 [m
 PACKAGE ?= jura_crdppf[m
[1mdiff --git a/client/Dockerfile b/client/Dockerfile[m
[1mindex 665e09c..b2e7f0f 100644[m
[1m--- a/client/Dockerfile[m
[1m+++ b/client/Dockerfile[m
[36m@@ -1,6 +1,6 @@[m
 FROM python:3.9-slim[m
 ARG PIP_OPTIONS=[m
[31m-#ARG PIP_OPTIONS="--trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple"[m
[32m+[m[32mARG PIP_OPTIONS="--trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple"[m
 [m
 COPY . /app[m
 [m
[1mdiff --git a/client/setup.py b/client/setup.py[m
[1mindex 068a49d..e51eda2 100644[m
[1m--- a/client/setup.py[m
[1m+++ b/client/setup.py[m
[36m@@ -1,7 +1,7 @@[m
 from setuptools import setup, find_packages[m
 [m
 requires = [[m
[31m-    'oereb-client==2.0.0'[m
[32m+[m[32m    'oereb-client==2.0.1.dev202204111425'[m
 ][m
 [m
 setup(name='jura_crdppf_client',[m
