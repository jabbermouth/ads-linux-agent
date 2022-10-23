FROM ubuntu:20.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu-dev \
        libunwind8 \
        netcat \
        libssl1.0 \
		unzip \
        wget \
        apt-transport-https \
        software-properties-common \
        dirmngr \
        gnupg

# Install PowerShell
RUN wget -q "https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb" \
&& dpkg -i packages-microsoft-prod.deb \
&& apt-get update \
&& apt-get install -y powershell

# Install Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
&& apt-add-repository 'deb https://download.mono-project.com/repo/ubuntu stable-focal main' \
&& apt install mono-complete 

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]