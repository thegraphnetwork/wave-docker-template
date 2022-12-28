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
ARG UID=1000
ARG GID=1000

RUN apt-get update -y \
  && apt-get install -y \
    build-essential \
    curl \
    tini \
  && rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/archives \
    /tmp/*

RUN addgroup --gid ${GID} epigraphhub \
  && useradd --uid ${UID} --gid ${GID} -ms /bin/bash epigraphhub \
  && mkdir -p /opt/services \
  && chmod -R a+rwx /opt/conda /opt/services \
  && export ENV_NAME="$ENV_NAME" \
  && chown epigraphhub:epigraphhub /opt/services


USER epigraphhub

COPY --chown=epigraphhub:epigraphhub ./conda/ /tmp/conda

WORKDIR /opt/services/waveapp

ENV PATH /opt/conda/envs/$ENV_NAME/bin:$PATH
ENV PYTHONPATH='/opt/services/waveapp'

RUN mamba env create -n $ENV_NAME --file /tmp/conda/containers.yaml \
  && conda clean --all \
  && find /opt/conda/ -type f,l -name '*.a' -delete \
  && find /opt/conda/ -type f,l -name '*.pyc' -delete \
  && find /opt/conda/ -type f,l -name '*.js.map' -delete \
  && rm -rf /opt/conda/pkgs /tmp/*

COPY --chown=epigraphhub:epigraphhub ./ /opt/services/waveapp/

RUN poetry config virtualenvs.create false \
  && poetry install

COPY --chown=epigraphhub:epigraphhub containers/entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh \
  && echo "source /opt/entrypoint.sh" > ~/.bashrc

ENTRYPOINT ["tini", "--", "/opt/entrypoint.sh"]

#CMD ["wave run --no-reload --no-autostart app.app"]
