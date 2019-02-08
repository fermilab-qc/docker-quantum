ARG DOCKER_TAG=latest
FROM docker.io/fermilabqc/quantum-full:${DOCKER_TAG}

USER root

RUN rm -f /var/lib/rpm/__db.* # workaround for problems in Docker Cloud?

RUN rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && curl https://download.mono-project.com/repo/centos7-stable.repo > /etc/yum.repos.d/mono-centos7-stable.repo
RUN echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

RUN dnf -y install mono-core mono-devel mono-winfxcore libmono-2_0-devel dotnet-sdk-2.1 code clang bzip2 tar which git libgomp

USER $NB_USER
WORKDIR $GITDIR

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

RUN git clone https://github.com/holzman/Quantum.git

USER root
RUN dnf -y install libX11-xcb compat-openssl10-devel

USER $NB_USER
RUN cd Quantum && git checkout linux  && code . && cd Samples/Teleportation && dotnet build

RUN conda install 'python==3.6.4' && conda clean -tipsy

USER root
RUN dnf -y install glib2-devel
USER $NB_USER
RUN source activate && pip install git+https://github.com/holzman/pythonnet

RUN conda env create -f $GITDIR/Quantum/Samples/PythonInterop/environment.yml && conda clean -tipsy
RUN source activate qsharp-samples && conda install ipykernel
RUN cd Quantum/Samples/PythonInterop && dotnet build && dotnet publish


ENV LD_LIBRARY_PATH=$GITDIR/Quantum/Samples/PythonInterop/bin/Debug/netstandard2.0/publish/runtimes/linux-x64/native/
ENV PYTHONPATH=$PYTHONPATH:$GITDIR/Quantum/Interoperability/python

####

FROM docker.io/fermilabqc/base-notebook
USER root

ENV GITDIR /srv/git
RUN dnf -y install glibc-devel libgomp


COPY --from=0 $CONDA_DIR $CONDA_DIR

# hackery - users need write access to openfermion/data (!)
RUN chown -R $NB_UID:$NB_GID $CONDA_DIR/lib/python3.6/site-packages/openfermion/data

COPY --from=0 $GITDIR $GITDIR
COPY --from=0 /usr/lib64/libmonosgen-2.0.so.1.0.0 /usr/lib64/libmonosgen-2.0.so.1.0.0
COPY --from=0 /usr/lib/mono /usr/lib/mono

RUN ldconfig && chown -R $NB_UID:$NB_GID $GITDIR

USER $NB_USER

ENV PYTHONPATH $GITDIR/Quantum/Interoperability/python
ENV LD_LIBRARY_PATH $GITDIR/Quantum/Samples/PythonInterop/bin/Debug/netstandard2.0/publish/runtimes/linux-x64/native/
WORKDIR $GITDIR
