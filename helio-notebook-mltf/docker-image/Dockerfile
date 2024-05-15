ARG PANGEO_BASE_IMAGE_TAG=2022.09.21
FROM pangeo/base-image:${PANGEO_BASE_IMAGE_TAG}

USER root
# - upgrade environment (probably should be in helio-base?)
RUN apt update -y
RUN apt-get install -y build-essential
RUN apt -y dist-upgrade
RUN apt-get update --fix-missing

RUN apt install -y apt-utils software-properties-common
RUN apt-add-repository universe
RUN apt-add-repository multiverse

# Install Message Of The Day (motd)
RUN echo "cat /etc/motd" > /etc/profile.d/show_motd.sh
COPY --chown=1000:1000 motd /etc/
RUN chmod 644 /etc/motd

# and then install Jupyter Lab extensions you need
RUN set -ex \
   && jupyter lab build -y \
   && jupyter lab clean -y

# install CDFLIB
RUN sh install_cdflib.sh
ENV CDF_LIB=/usr/lib64/cdf/lib

# needed to pick up libcuda.so
RUN ln -s ${NB_PYTHON_PREFIX}/lib/stubs/libcuda.so ${NB_PYTHON_PREFIX}/lib/stubs/libcuda.so.1
ENV LD_LIBRARY_PATH=${NB_PYTHON_PREFIX}/lib/
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# jupyterlab-s3 browser 
COPY --chown=1000:1000 jupyterlab_s3_browser.json /srv/conda/envs/$CONDA_ENV/etc/jupyter/jupyter_notebook_config.d/

##-Cleanup temporary data
USER root
RUN apt clean
RUN apt autoclean
RUN apt -y autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup work directory for backward-compatibility
USER $NB_USER
WORKDIR $HOME

COPY --chown=1000:1000 bash_profile .bash_profile
RUN touch .bashrc
COPY --chown=1000:1000 srv-conda-condarc /srv/conda/.condarc
CMD $conda init bash

USER root
