ARG PANGEO_BASE_IMAGE_TAG=2024.01.15
FROM pangeo/base-image:${PANGEO_BASE_IMAGE_TAG}

LABEL org.opencontainers.image.source=https://github.com/heliocloud-data/runtimes

USER root
# - upgrade environment (probably should be in helio-base?)
RUN apt update -y
RUN apt-get install -y build-essential
RUN apt -y dist-upgrade
RUN apt-get update --fix-missing

RUN apt install -y apt-utils software-properties-common
RUN apt-add-repository universe
RUN apt-add-repository multiverse

# FIX, pangeo base-image doesnt set mod to read by user
RUN chmod 644 /etc/jupyter/jupyter_notebook_config.py

# Install Message Of The Day (motd)
RUN echo "cat /etc/motd" > /etc/profile.d/show_motd.sh
COPY --chown=1000:1000 motd /etc/
RUN chmod 644 /etc/motd

# Install Jupyter Lab extensions we need
RUN set -ex \
   && jupyter lab build -y \
   && jupyter lab clean -y

# needed to pick up libcuda.so
# RUN ln -s ${NB_PYTHON_PREFIX}/lib/stubs/libcuda.so ${NB_PYTHON_PREFIX}/lib/stubs/libcuda.so.1
# ENV LD_LIBRARY_PATH=${NB_PYTHON_PREFIX}/lib/
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
  
# Required for nvidia drivers to work inside the image on GKE
# No-ops on other platforms - Azure doesn't need these set.
# Shouldn't negatively affect anyone, and makes life easier on GKE.
ENV PATH=${PATH}:/usr/local/nvidia/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/nvidia/lib64

# install CDFLIB
RUN sh install_cdflib.sh
ENV CDF_LIB=/usr/lib64/cdf/lib

# Install some PyHC packages directly here.
RUN pip install --no-cache-dir spacepy --no-build-isolation && \
    pip install --no-cache-dir git+https://github.com/nasa/Kamodo.git && \
    pip install --no-cache-dir git+https://github.com/wtbarnes/fiasco.git && \
    pip install --no-cache-dir pytplot-mpl-temp && \
    pip install --no-cache-dir pyspedas

##- Cleanup temporary data
RUN apt clean \
   && apt autoclean \
   && apt -y autoremove \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   && conda clean -afy

# User account configuration
# Setup work directory for backward-compatibility
USER $NB_USER
WORKDIR $HOME

# create PyHC package data dirs (needed?)
RUN mkdir -p $NB_USER/.sunpy $NB_USER/.spacepy/data

# user account starting environment
COPY --chown=1000:1000 bash_profile .bash_profile
RUN touch .bashrc
COPY --chown=1000:1000 srv-conda-condarc /srv/conda/.condarc
CMD /usr/bin/chown $NB_USER.$NB_USER -R $HOME
CMD $conda init bash

USER root
