FROM python:3.6

MAINTAINER Henry Mei

ENV PYTHONUNBUFFERED 1
ARG DS_DIR=ds_stack

WORKDIR /$DS_DIR/notebooks

COPY init.sh /$DS_DIR/

COPY requirements.txt requirements.local.txt* /$DS_DIR/
RUN pip install -r /$DS_DIR/requirements.txt && \
    pip install -r /$DS_DIR/requirements.local.txt || true

ENTRYPOINT ../init.sh
