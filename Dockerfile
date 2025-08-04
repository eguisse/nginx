# syntax=docker/dockerfile:1.4
FROM bitnami/nginx:1.29-debian-12

USER root
ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

RUN apt-get update -y && \
    apt-get install -y curl jq && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives


ENV APP_VERSION="1.29.0" \
    BITNAMI_APP_NAME="nginx" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080 8443

STOPSIGNAL SIGQUIT
WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
