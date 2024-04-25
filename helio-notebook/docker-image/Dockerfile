#ARG PANGEO_BASE_IMAGE_TAG=2024.02.27
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

# install CDFLIB
RUN sh install_cdflib.sh
ENV CDF_LIB=/usr/lib64/cdf/lib

# jupyterlab-s3 browser 
COPY --chown=1000:1000 jupyterlab_s3_browser.json /srv/conda/envs/$CONDA_ENV/etc/jupyter/jupyter_notebook_config.d/

##-Cleanup temporary data
USER root

# Install PyHC packages with pip (SpacePy, Kamodo, and pySPEDAS separately)
#RUN pip install --no-cache-dir numpy==1.24.3 && \
#COPY --chown=1000:1000 requirements_pyhc.txt /var/tmp

RUN pip install --no-cache-dir spacepy --no-build-isolation && \
#    pip install --use-pep517 --retries 5 --no-cache-dir -r /var/tmp/requirements_pyhc.txt && \
    pip install --no-cache-dir git+https://github.com/nasa/Kamodo.git && \
    pip install --no-cache-dir git+https://github.com/plasmapy/plasmapy.git && \
    pip install --no-cache-dir git+https://github.com/wtbarnes/fiasco.git && \
    pip install --no-cache-dir pytplot-mpl-temp && \
    pip install --no-cache-dir pyspedas

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
CMD /usr/bin/chown $NB_USER.$NB_USER -R $HOME
CMD $conda init bash

USER root
