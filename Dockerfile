FROM docker.io/holzman/cirq-notebook

USER root
### 
# Q# - Microsoft
RUN rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && curl https://download.mono-project.com/repo/centos7-stable.repo > /etc/yum.repos.d/mono-centos7-stable.repo
RUN echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

RUN dnf -y install mono-core mono-devel mono-winfxcore libmono-2_0-devel dotnet-sdk-2.1 code clang bzip2 tar which git libgomp
RUN mkdir -p /srv/git && chown $NB_UID:$NB_GID /srv/git

ENV GITDIR=/srv/git
USER $NB_USER
WORKDIR $GITDIR

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

RUN git clone https://github.com/holzman/Quantum.git
RUN cd Quantum && git fetch origin && git checkout linux && git pull origin linux && code . && cd Samples/Teleportation && dotnet build

###

# PyQuil - Rigetti
RUN pip install pyquil

# QISKit - IBM
RUN pip install qiskit

# ProjectQ
RUN pip install pybind11
RUN LC_ALL=en_US.UTF-8 pip install projectq

RUN conda install 'python==3.6.4' && conda clean -tipsy
RUN pip install git+https://github.com/holzman/pythonnet
RUN conda env create -f $GITDIR/Quantum/Samples/PythonInterop/environment.yml && conda clean -tipsy

RUN conda install nb_conda && conda clean -tipsy

USER root
RUN source activate qsharp-samples && conda install ipykernel

USER $NB_USER
RUN cd Quantum/Samples/PythonInterop && dotnet build && dotnet publish

USER root
RUN conda config --add channels http://conda.anaconda.org/psi4 && conda install psi4 && conda clean -tipsy
RUN LC_ALL=en_US.UTF-8 pip install git+https://github.com/quantumlib/OpenFermion git+https://github.com/quantumlib/OpenFermion-Cirq openfermionpyscf git+https://github.com/quantumlib/OpenFermion-Psi4

# hackery - users need write access to openfermion (!)
RUN chown -R $NB_UID:$NB_GID $CONDA_DIR/lib/python3.6/site-packages/openfermion*

USER $NB_USER
RUN git clone https://github.com/quantumlib/OpenFermion && git clone https://github.com/quantumlib/OpenFermion-PySCF && git clone https://github.com/quantumlib/OpenFermion-Psi4

ENV LD_LIBRARY_PATH=$GITDIR/Quantum/Samples/PythonInterop/bin/Debug/netstandard2.0/publish/runtimes/linux-x64/native/
ENV PYTHONPATH=$PYTHONPATH:$GITDIR/Quantum/Interoperability/python
RUN ln -s /home/jovyan $GITDIR/work

USER $NB_USER
