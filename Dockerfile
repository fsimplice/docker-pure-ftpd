FROM alpine:3.5
LABEL maintainer fsimplice@laposte.net

ENV DOCKER_USER_NAME=docker \
    DOCKER_USER_UID=1000 \
    DOCKER_GROUP_NAME=docker \
    DOCKER_GROUP_UID=1000
    
RUN apk update \
    && apk add \
        su-exec \
    && rm -rf /var/cache
    
RUN addgroup -g ${DOCKER_GROUP_UID} ${DOCKER_GROUP_NAME} &&\
    adduser -G ${DOCKER_GROUP_NAME} -u ${DOCKER_USER_UID} -D ${DOCKER_USER_NAME}

#USER ${DOCKER_USER_NAME}


