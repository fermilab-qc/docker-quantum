FROM docker.io/holzman/cirq-notebook

USER root
### 
# Q# - Microsoft
RUN rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && curl https://download.mono-project.com/repo/centos7-stable.repo > /etc/yum.repos.d/mono-centos7-stable.repo
RUN echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

RUN dnf -y install mono-core mono-devel mono-winfxcore libmono-2_0-devel
RUN dnf -y install dotnet-sdk-2.1 code 
RUN dnf -y install clang

USER user
WORKDIR /home/user

RUN git clone https://github.com/holzman/Quantum.git
RUN cd Quantum && git fetch origin && git checkout linux && git pull origin linux
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN cd Quantum; code .; cd Samples/Teleportation; dotnet build


###

# PyQuil - Rigetti
RUN pip install pyquil

# QISKit - IBM
RUN pip install qiskit

# ProjectQ
RUN pip install pybind11
RUN LC_ALL=en_US.UTF-8 pip install projectq

RUN conda install 'python==3.6.4'
RUN pip install git+https://github.com/holzman/pythonnet
RUN conda env create -f /home/user/Quantum/Samples/PythonInterop/environment.yml

RUN conda install nb_conda
RUN activate qsharp-samples && conda install ipykernel

RUN cd Quantum/Samples/PythonInterop && dotnet build && dotnet publish

RUN conda config --add channels http://conda.anaconda.org/psi4 && conda install psi4
RUN LC_ALL=en_US.UTF-8 pip install openfermioncirq openfermionpyscf openfermionpsi4
RUN conda install -c conda-forge jupyterlab

RUN git clone https://github.com/quantumlib/OpenFermion && git clone https://github.com/quantumlib/OpenFermion-PySCF && git clone https://github.com/quantumlib/OpenFermion-Psi4

ENV LD_LIBRARY_PATH=/home/user/Quantum/Samples/PythonInterop/bin/Debug/netstandard2.0/publish/runtimes/linux-x64/native/

USER $NB_USER
