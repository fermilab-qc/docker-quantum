ARG DOCKER_TAG=latest
FROM docker.io/fermilabqc/base-notebook:${DOCKER_TAG}

USER root
ENV GITDIR=/srv/git

RUN dnf -y install git libgomp gcc
RUN mkdir -p $GITDIR && chown $NB_UID:$NB_GID $GITDIR && ln -s /home/$NB_USER $GITDIR/work

USER $NB_USER
WORKDIR $GITDIR

# Cirq, QISKit, QuTiP
RUN source activate && pip install cirq==0.4.0 && pip install qiskit==0.13.0

# OpenFermion
RUN source activate && LC_ALL=en_US.UTF-8 pip install openfermion openfermioncirq

# hackery - users need write access to openfermion/data (!)
RUN chown -R $NB_UID:$NB_GID $CONDA_DIR/lib/python3.7/site-packages/openfermion/data
RUN git clone https://github.com/quantumlib/OpenFermion && git clone https://github.com/kevinsung/OpenFermion-Hands-On-Tutorials

# QuTiP
RUN conda install qutip==4.4.1 && conda clean -tipsy
