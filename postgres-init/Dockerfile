FROM postgres

ARG SOURCE
ARG COMMIT_HASH
ARG COMMIT_ID
ARG BUILD_TIME
LABEL source=${SOURCE}
LABEL commit_hash=${COMMIT_HASH}
LABEL commit_id=${COMMIT_ID}
LABEL build_time=${BUILD_TIME}

ARG container_user=mosip
ARG container_user_group=mosip
ARG container_user_uid=1001
ARG container_user_gid=1001

# Install packages and create user in a single layer to minimize image size
RUN apt-get update \
  && apt-get install -y --no-install-recommends git unzip ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && groupadd -g ${container_user_gid} ${container_user_group} \
  && useradd -u ${container_user_uid} -g ${container_user_group} -s /bin/sh -m ${container_user}

WORKDIR /home/${container_user}/repos/

# Runtime environment variables (overridden at deploy time via ConfigMap / secrets)
ENV GIT_REPO_URL=
ENV GIT_BRANCH=
ENV MOSIP_DB_NAME=
ENV DB_SERVERIP=
ENV DB_PORT=5432
ENV DEFAULT_DB_NAME=postgres
ENV SU_USER=postgres
ENV SU_USER_PWD=
ENV DB_UNAME=
ENV DBUSER_PWD=
ENV DML_FLAG=

COPY postgres-init.sh postgres-init.sh

# Change permissions of file inside working dir
RUN chown -R ${container_user}:${container_user} /home/${container_user}/repos/

# Run as non-root user
USER ${container_user_uid}:${container_user_gid}

ENTRYPOINT ["./postgres-init.sh"]
