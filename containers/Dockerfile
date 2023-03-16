# ref: https://github.com/mamba-org/micromamba-docker/blob/main/Dockerfile

FROM condaforge/mambaforge:latest

LABEL maintainer="Sandro Loch <es.loch@gmail.com>"
LABEL org.opencontainers.image.title="EpiGraphHub"
LABEL org.opencontainers.image.authors="EpiGraphHub Team"
LABEL org.opencontainers.image.source="https://github.com/thegraphnetwork/wave-docker-template"
LABEL org.opencontainers.image.version="latest"
LABEL org.opencontainers.image.description="EpiGraphHub"
LABEL org.thegraphnetwork.epigraphhub.version="latest"

# it is the default, but using it here to have it explicitly
USER root

SHELL ["/bin/bash", "-c"]
# Use bash in Dockerfile RUN commands and make sure bashrc is sourced when
# executing commands with /bin/bash -c
# Needed to have the micromamba activate command configured etc.

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
  && mkdir -p /opt/services \
  && chmod -R a+rwx /opt/conda /opt/services \
  && export ENV_NAME="$ENV_NAME" \
  && chown -R ${HOST_GID}:${HOST_GID} /opt/services

ENV PATH /opt/conda/envs/$ENV_NAME/bin:$PATH
ENV PATH "$PATH:/home/epigraphhub/.local/bin"
ENV PYTHONPATH='/opt/services/waveapp'

USER epigraphhub

COPY --chown=${HOST_GID}:${HOST_GID} ./ /opt/services/waveapp/
COPY --chown=${HOST_GID}:${HOST_GID} containers/entrypoint.sh /opt/entrypoint.sh
COPY --chown=${HOST_GID}:${HOST_GID} conda/wave-base.yaml /tmp/containers.yaml
COPY --chown=${HOST_GID}:${HOST_GID} containers/scripts/poetry-install.sh /opt/services/poetry-install.sh
COPY --chown=${HOST_GID}:${HOST_GID} poetry.lock pyproject.toml /opt/services/

RUN chmod +x /opt/entrypoint.sh \
  && echo "source /opt/entrypoint.sh" > ~/.bashrc

RUN conda env create -n waveapp --file /tmp/containers.yaml
  && conda clean --all \
  && find /opt/conda/ -type f,l -name '*.a' -delete \
  && find /opt/conda/ -type f,l -name '*.pyc' -delete \
  && find /opt/conda/ -type f,l -name '*.js.map' -delete \
  && rm -rf /home/airflow/.conda/pkgs

WORKDIR /opt/services/waveapp

RUN bash /opt/services/poetry-install.sh

ENTRYPOINT ["tini", "--", "/opt/entrypoint.sh"]
