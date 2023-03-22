# ref: https://github.com/mamba-org/micromamba-docker/blob/main/Dockerfile

FROM condaforge/mambaforge:latest

LABEL maintainer="Sandro Loch <es.loch@gmail.com>"
LABEL org.opencontainers.image.title="EpiGraphHub"
LABEL org.opencontainers.image.authors="EpiGraphHub Team"
LABEL org.opencontainers.image.source="https://github.com/thegraphnetwork/wave-docker-template"
LABEL org.opencontainers.image.version="latest"
LABEL org.opencontainers.image.description="EpiGraphHub"
LABEL org.thegraphnetwork.epigraphhub.version="latest"

USER root

SHELL ["/bin/bash", "-c"]

ENV ENV_NAME=waveapp
ENV DEBIAN_FRONTEND=noninteractive
ARG HOST_UID=1000
ARG HOST_GID=1000

RUN apt-get update -y \
  && apt-get install -y \
    build-essential \
    curl \
    tini \
  && rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/archives \
    /tmp/*

RUN addgroup --gid ${HOST_GID} epigraphhub \
  && useradd --uid ${HOST_UID} --gid ${HOST_GID} -ms /bin/bash epigraphhub \
  && mkdir -p /opt/services/waveapp_pkg/waveapp \
  && chmod -R a+rwx /opt/conda /opt/services \
  && export ENV_NAME="$ENV_NAME" \
  && chown -R ${HOST_GID}:${HOST_GID} /opt/services

ENV PATH /opt/conda/envs/$ENV_NAME/bin:$PATH
ENV PATH "$PATH:/opt/services/.local/bin"
ENV PYTHONPATH='/opt/services/waveapp_pkg'

# Install Wave
ARG WAVE_VERSION="0.20.0"

ENV WAVE_HOME="/opt/services/wave"
RUN \
    mkdir -p "${WAVE_HOME}" && \
    curl -fsSL https://github.com/h2oai/wave/releases/download/v${WAVE_VERSION}/wave-${WAVE_VERSION}-linux-amd64.tar.gz | tar -C ${WAVE_HOME} -xzv 2>&1
ENV WAVE_PATH="${WAVE_HOME}/wave-${WAVE_VERSION}-linux-amd64"

USER epigraphhub

COPY --chown=${HOST_GID}:${HOST_GID} conda/wave-base.yaml /tmp/containers.yaml

RUN conda env create -n waveapp --file /tmp/containers.yaml \
  && conda clean --all \
  && find /opt/conda/ -type f,l -name '*.a' -delete \
  && find /opt/conda/ -type f,l -name '*.pyc' -delete \
  && find /opt/conda/ -type f,l -name '*.js.map' -delete

WORKDIR /opt/services/waveapp_pkg/

COPY --chown=${HOST_GID}:${HOST_GID} waveapp /opt/services/waveapp_pkg/waveapp

COPY --chown=${HOST_GID}:${HOST_GID} containers/scripts/poetry-install.sh /opt/services/waveapp_pkg/poetry-install.sh
COPY --chown=${HOST_GID}:${HOST_GID} poetry.lock pyproject.toml /opt/services/waveapp_pkg/
RUN bash /opt/services/waveapp_pkg/poetry-install.sh

COPY --chown=${HOST_GID}:${HOST_GID} containers/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh \
  && echo "source /opt/entrypoint.sh" > ~/.bashrc

ENTRYPOINT ["tini", "--", "/opt/entrypoint.sh"]
