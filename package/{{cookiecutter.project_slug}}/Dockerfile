FROM alpine:latest as python-base

ENV PORT 9000
ENV PYTHONUNBUFFERED 1
ENV PYTHONOPTIMIZE 2
WORKDIR /app
ENTRYPOINT ["./entrypoint.sh"]
EXPOSE ${PORT}
STOPSIGNAL SIGINT

RUN apk --update --no-cache add python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    rm -r /usr/lib/python*/lib2to3 && \
    rm -r /usr/lib/python*/turtledemo && \
    rm /usr/lib/python*/turtle.py && \
    rm /usr/lib/python*/webbrowser.py && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    rm -rf /root/.cache /var/cache /usr/share/terminfoapk

FROM python-base AS build-dependencies

COPY etc/docker/requirements-apk etc/docker/requirements-apk-build ./
RUN apk update && \
    apk --no-cache --virtual requirements-apk add $(cat requirements-apk | grep -v '#' | xargs) && \
    apk --no-cache --virtual requirements-apk-build add $(cat requirements-apk-build | grep -v '#' | xargs) && \
    rm -rf /root/.cache /var/cache /usr/share/terminfoapk

FROM build-dependencies as requirements

COPY requirements/base.txt ./
RUN pip3 install --no-cache-dir -r base.txt && \
    apk del requirements-apk-build

FROM requirements as code

ARG VERSION
ARG REVISION
ARG TIMESTAMP

COPY entrypoint.sh ./
COPY data ./
COPY {{ cookiecutter.project_slug }} ./
COPY settings ./
RUN find / -type d -name __pycache__ -exec rm -r {} +

ENV VERSION=${VERSION}
ENV REVISION=${REVISION}
ENV TIMESTAMP=${TIMESTAMP}

LABEL org.opencontainers.image.created=${TIMESTAMP}
LABEL org.opencontainers.image.authors="{{ cookiecutter.email }}"
LABEL org.opencontainers.image.url="{{ cookiecutter.vcs_url }}"
{% if cookiecutter.vcs == 'gitlab' -%}
LABEL org.opencontainers.image.documentation="https://{{ cookiecutter.vcs_username }}.gitlab.io/{{ cookiecutter.vcs_project_name }}/index.html"
{% elif cookiecutter.vcs == 'github' -%}
LABEL org.opencontainers.image.documentation="https://{{ cookiecutter.vcs_project_name }}.readthedocs.io/en/latest/?badge=latest"
{% endif -%}
LABEL org.opencontainers.image.source="{{ cookiecutter.vcs_url }}"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.vendor="{{ cookiecutter.author }}"
LABEL org.opencontainers.image.licenses="{{ cookiecutter.license }}"
LABEL org.opencontainers.image.title="{{ cookiecutter.project_name }}"
LABEL org.opencontainers.image.description="{{ cookiecutter.project_short_description }}"
LABEL org.opencontainers.image.base.name="alpine:latest"
