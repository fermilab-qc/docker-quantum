ARG DOCKER_TAG=latest
FROM docker.io/fermilabqc/base-notebook:${DOCKER_TAG}

USER root
ENV GITDIR=/srv/git

RUN dnf -y install git libgomp gcc
RUN mkdir -p $GITDIR && chown $NB_UID:$NB_GID $GITDIR && ln -s /home/$NB_USER $GITDIR/work

USER $NB_USER
WORKDIR $GITDIR

# Cirq, QISKit, QuTiP
RUN source activate && pip install cirq==0.3.1.35 && pip install qiskit==0.6.1

# OpenFermion
RUN source activate && LC_ALL=en_US.UTF-8 pip install \
	openfermion==0.8.1 openfermionpyscf==0.3 openfermionpsi4==0.4 openfermioncirq==0.2.1a35
# hackery - users need write access to openfermion/data (!)
RUN chown -R $NB_UID:$NB_GID $CONDA_DIR/lib/python3.6/site-packages/openfermion/data
RUN git clone https://github.com/quantumlib/OpenFermion && git clone https://github.com/kevinsung/OpenFermion-Hands-On-Tutorials

# QuTiP
RUN conda install qutip==4.3.1 && conda clean -tipsy
