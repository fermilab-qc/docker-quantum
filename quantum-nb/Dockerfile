FROM docker.io/holzman/cirq-notebook

USER root
RUN dnf -y install gcc gcc-c++ git

RUN mkdir -p /srv/git && chown $NB_UID:$NB_GID /srv/git

ENV GITDIR=/srv/git
USER $NB_USER
WORKDIR $GITDIR

###

# PyQuil - Rigetti
RUN source activate && pip install pyquil==1.9.0

# QISKit - IBM
RUN source activate && pip install qiskit==0.5.7

# ProjectQ
RUN source activate && pip install pybind11==2.2.4
RUN LC_ALL=en_US.UTF-8 pip install projectq==0.4.1

# QuTIP
RUN conda install qutip==4.3.1 && conda clean -tipsy

RUN conda install nb_conda && conda clean -tipsy

RUN conda config --add channels http://conda.anaconda.org/psi4 && conda install psi4=1.2.1+406f4de && conda clean -tipsy

RUN source activate && LC_ALL=en_US.UTF-8 pip install \
	openfermion==0.8.1 cirq==0.3.1.35 openfermionpyscf==0.3 openfermionpsi4==0.4 openfermioncirq==0.2.1a35

# hackery - users need write access to openfermion/data (!)
RUN chown -R $NB_UID:$NB_GID $CONDA_DIR/lib/python3.6/site-packages/openfermion/data

RUN git clone https://github.com/quantumlib/OpenFermion && git clone https://github.com/quantumlib/OpenFermion-PySCF && git clone https://github.com/quantumlib/OpenFermion-Psi4 && git clone  https://github.com/kevinsung/OpenFermion-Hands-On-Tutorials

RUN ln -s /home/jovyan $GITDIR/work

USER $NB_USER
