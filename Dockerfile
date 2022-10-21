FROM ubuntu:20.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
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
        software-properties-common

RUN wget -q "https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb" \
&& dpkg -i packages-microsoft-prod.deb \
&& apt-get update \
&& apt-get install -y powershell

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]