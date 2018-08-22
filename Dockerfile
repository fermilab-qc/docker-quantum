FROM fedora:23

RUN dnf -y install bzip2 tar which git libgomp
RUN groupadd -g 501 user && useradd -m -u 501 -g 501 -s /bin/bash user

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
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN cd Quantum; code .; cd Samples/Teleportation; dotnet build


###

RUN curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O && bash ./Miniconda3-latest-Linux-x86_64.sh -b

# Cirq - Google
RUN source /home/user/miniconda3/bin/activate && pip install jupyter cirq

# PyQuil - Rigetti
RUN source /home/user/miniconda3/bin/activate && pip install pyquil

# QISKit - IBM
RUN source /home/user/miniconda3/bin/activate && pip install qiskit

# ProjectQ
RUN source /home/user/miniconda3/bin/activate && pip install pybind11
RUN source /home/user/miniconda3/bin/activate && LC_ALL=en_US.UTF-8 pip install projectq

RUN source /home/user/miniconda3/bin/activate && conda install 'python==3.6.4'
RUN source /home/user/miniconda3/bin/activate && pip install git+https://github.com/holzman/pythonnet
#RUN source /home/user/miniconda3/bin/activate && pip install git+https://github.com/pythonnet/pythonnet
RUN cd Quantum && git fetch origin && git checkout linux && git pull origin linux # bh
RUN source /home/user/miniconda3/bin/activate && conda env create -f /home/user/Quantum/Samples/PythonInterop/environment.yml

RUN source /home/user/miniconda3/bin/activate && conda install nb_conda
RUN source /home/user/miniconda3/bin/activate qsharp-samples && conda install ipykernel
RUN cd Quantum/Samples/PythonInterop && dotnet build && dotnet publish

RUN cd Quantum && git fetch origin && git checkout linux && git pull origin linux # 3a5e2b21d6

RUN source /home/user/miniconda3/bin/activate && conda config --add channels http://conda.anaconda.org/psi4 && conda install psi4
RUN source /home/user/miniconda3/bin/activate && git clone https://github.com/quantumlib/OpenFermion-Psi4 && cd OpenFermion-Psi4 && pip install -e .
RUN source /home/user/miniconda3/bin/activate && LC_ALL=en_US.UTF-8 pip install openfermioncirq openfermionpyscf
RUN source /home/user/miniconda3/bin/activate && conda install -c conda-forge jupyterlab


RUN git clone https://github.com/quantumlib/OpenFermion && git clone https://github.com/quantumlib/OpenFermion-PySCF



ENV LD_LIBRARY_PATH=/home/user/Quantum/Samples/PythonInterop/bin/Debug/netstandard2.0/publish/runtimes/linux-x64/native/

CMD source /home/user/miniconda3/bin/activate && jupyter lab  --no-browser --ip=`tail -1 /etc/hosts | awk '{print $1}'` --port=${JUPYTER_PORT:-8888}
