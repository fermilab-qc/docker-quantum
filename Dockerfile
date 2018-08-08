FROM centos:7

RUN yum -y install bzip2
RUN groupadd -g 501 user && useradd -m -u 501 -g 501 -s /bin/bash user

USER user
WORKDIR /home/user

RUN curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O && bash ./Miniconda3-latest-Linux-x86_64.sh -b

# Cirq - Google
RUN source /home/user/miniconda3/bin/activate && pip install jupyter cirq

# PyQuil - Rigetti
RUN source /home/user/miniconda3/bin/activate && pip install pyquil

# QISKit - IBM
RUN source /home/user/miniconda3/bin/activate && pip install qiskit

# Q# - Microsoft
USER root
RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
RUN yum -y install dotnet-sdk-2.1
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
RUN yum -y install code git
RUN yum -y install which
RUN yum -y install libgomp
RUN yum -y update libstdc++
CMD bash
#USER user
#RUN git clone https://github.com/Microsoft/Quantum.git
#ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
#RUN cd Quantum; code .; cd Samples/Teleportation; dotnet build
#CMD source /home/user/miniconda3/bin/activate && jupyter notebook --no-browser --port=${JUPYTER_PORT:-8888}