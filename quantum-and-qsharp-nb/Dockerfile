FROM docker.io/holzman/cirq-notebook

USER root
RUN rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && curl https://download.mono-project.com/repo/centos7-stable.repo > /etc/yum.repos.d/mono-centos7-stable.repo
RUN echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

RUN dnf -y install mono-core mono-devel mono-winfxcore libmono-2_0-devel dotnet-sdk-2.1 code clang bzip2 tar which git libgomp

USER $NB_USER
WORKDIR $GITDIR

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

RUN git clone https://github.com/holzman/Quantum.git
RUN cd Quantum && git fetch origin && git checkout linux && git pull origin linux && code . && cd Samples/Teleportation && dotnet build

RUN conda install 'python==3.6.4' && conda clean -tipsy
RUN source activate && pip install git+https://github.com/holzman/pythonnet

RUN conda env create -f $GITDIR/Quantum/Samples/PythonInterop/environment.yml && conda clean -tipsy
RUN source activate qsharp-samples && conda install ipykernel

ENV LD_LIBRARY_PATH=$GITDIR/Quantum/Samples/PythonInterop/bin/Debug/netstandard2.0/publish/runtimes/linux-x64/native/
ENV PYTHONPATH=$PYTHONPATH:$GITDIR/Quantum/Interoperability/python
