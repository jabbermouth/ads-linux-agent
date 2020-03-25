FROM ubuntu:16.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install software-properties-common -y \
&& add-apt-repository ppa:git-core/ppa \
&& apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		wget \		
        jq \
        git \
        iputils-ping \
        libcurl3 \
        libicu55 \
        libunwind8 \
        netcat

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
&& apt-get install -y nodejs \
&& npm install azure-pipelines-task-lib \
&& npm install @types/node \
&& npm install @types/q

RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb

RUN dpkg -i packages-microsoft-prod.deb

RUN apt-get install apt-transport-https
RUN apt-get update
RUN apt-get install dotnet-sdk-3.1

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]