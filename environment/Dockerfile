# hash:sha256:08da0a53adb4a4291e6045ca0ca52e50f37491980f75205ae3794f3d2c1ae63c
FROM registry.apps.codeocean.com/codeocean/mambaforge3:22.11.1-4-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

ARG GIT_ASKPASS
ARG GIT_ACCESS_TOKEN
COPY git-askpass /

RUN mamba install -y --channel=bioconda \
        ca-certificates==2023.7.22 \
        git==2.42.0 \
        sambamba==1.0 \
    && mamba clean -ya

RUN pip install -U --no-cache-dir \
    code-ocean-aux-tools==1.1.3

COPY postInstall /
RUN /postInstall
