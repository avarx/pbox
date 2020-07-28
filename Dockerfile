FROM ubuntu:18.04

LABEL maintainer="avarx"

# Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND=noninteractive


# Working Directory
WORKDIR /root
RUN mkdir ${HOME}/tools && \
    mkdir ${HOME}/wordlists

# Install Essentials
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    tmux \
    gcc \
    iputils-ping\
    git \
    vim \
    wget \
    awscli \
    tzdata \
    curl \
    make \
    nmap \
    whois \
    python \
    python-pip \
    python3 \
    python3-pip \
    perl \
    nikto \
    dnsutils \
    net-tools \
    zsh\
    nano\
    && rm -rf /var/lib/apt/lists/*

# Install Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # sqlmap
    sqlmap \
    # dirb
    dirb \
    # dnsenum
    cpanminus \
    # wfuzz
    python-pycurl \
    # knock
    python-dnspython \
    # massdns
    libldns-dev \
    # wpcscan
    libcurl4-openssl-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    ruby-dev \
    libgmp-dev \
    zlib1g-dev \
    # masscan
    libpcap-dev \
    # theharvester
    python3.7 \
    # joomscan
    libwww-perl \
    # hydra
    hydra \
    # dnsrecon
    dnsrecon \
    # zsh
    powerline\
    # zsh
    fonts-powerline\
    && rm -rf /var/lib/apt/lists/*

# tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Zurich /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# configure python(s)
RUN python -m pip install --upgrade setuptools && python3 -m pip install --upgrade setuptools && python3.7 -m pip install --upgrade setuptools

# dnsenum
RUN cd ${HOME}/tools && \
    git clone https://github.com/fwaeytens/dnsenum.git && \
    cd dnsenum/ && \
    chmod +x dnsenum.pl && \
    ln -s ${HOME}/tools/dnsenum/dnsenum.pl /usr/bin/dnsenum && \
    cpanm String::Random && \
    cpanm Net::IP && \
    cpanm Net::DNS && \
    cpanm Net::Netmask && \
    cpanm XML::Writer

# Sublist3r
RUN cd ${HOME}/tools && \
    git clone https://github.com/aboul3la/Sublist3r.git && \
    cd Sublist3r/ && \
    pip install -r requirements.txt && \
    ln -s ${HOME}/tools/Sublist3r/sublist3r.py /usr/local/bin/sublist3r

# wfuzz
RUN pip install wfuzz

# seclists
RUN cd ${HOME}/wordlists && \
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git

# knock
RUN cd ${HOME}/tools && \
    git clone https://github.com/guelfoweb/knock.git && \
    cd knock && \
    chmod +x setup.py && \
    python setup.py install

# massdns
RUN cd ${HOME}/tools && \
    git clone https://github.com/blechschmidt/massdns.git && \
    cd massdns/ && \
    make && \
    ln -sf ${HOME}/tools/massdns/bin/massdns /usr/local/bin/massdns

# wafw00f
RUN cd ${HOME}/tools && \
    git clone https://github.com/enablesecurity/wafw00f.git && \
    cd wafw00f && \
    chmod +x setup.py && \
    python setup.py install

# wpscan
RUN cd ${HOME}/tools && \
    git clone https://github.com/wpscanteam/wpscan.git && \
    cd wpscan/ && \
    gem install bundler && bundle install --without test && \
    gem install wpscan

# commix
RUN cd ${HOME}/tools && \
    git clone https://github.com/commixproject/commix.git && \
    cd commix && \
    chmod +x commix.py && \
    ln -sf ${HOME}/tools/commix/commix.py /usr/local/bin/commix

# masscan
RUN cd ${HOME}/tools && \
    git clone https://github.com/robertdavidgraham/masscan.git && \
    cd masscan && \
    make && \
    ln -sf ${HOME}/tools/masscan/bin/masscan /usr/local/bin/masscan

# altdns
RUN cd ${HOME}/tools && \
    git clone https://github.com/infosec-au/altdns.git && \
    cd altdns && \
    pip install -r requirements.txt && \
    chmod +x setup.py && \
    python setup.py install

# teh_s3_bucketeers
RUN cd ${HOME}/tools && \
    git clone https://github.com/tomdev/teh_s3_bucketeers.git && \
    cd teh_s3_bucketeers && \
    chmod +x bucketeer.sh && \
    ln -sf ${HOME}/tools/teh_s3_bucketeers/bucketeer.sh /usr/local/bin/bucketeer

# Recon-ng
RUN cd ${HOME}/tools && \
    git clone https://github.com/lanmaster53/recon-ng.git && \
    cd recon-ng && \
    pip3 install -r REQUIREMENTS && \
    chmod +x recon-ng && \
    ln -sf ${HOME}/tools/recon-ng/recon-ng /usr/local/bin/recon-ng

# XSStrike
RUN cd ${HOME}/tools && \
    git clone https://github.com/s0md3v/XSStrike.git && \
    cd XSStrike && \
    pip3 install -r requirements.txt && \
    chmod +x xsstrike.py && \
    ln -sf ${HOME}/tools/XSStrike/xsstrike.py /usr/local/bin/xsstrike

# theHarvester
RUN cd ${HOME}/tools && \
    git clone https://github.com/AlexisAhmed/theHarvester.git && \
    cd theHarvester && \
    python3.7 -m pip install -r requirements.txt && \
    chmod +x theHarvester.py && \
    ln -sf ${HOME}/tools/theHarvester/theHarvester.py /usr/local/bin/theharvester

# CloudFlair
RUN cd ${HOME}/tools && \
    git clone https://github.com/christophetd/CloudFlair.git && \
    cd CloudFlair && \
    pip install -r requirements.txt && \
    chmod +x cloudflair.py && \
    ln -sf ${HOME}/tools/CloudFlair/cloudflair.py /usr/local/bin/cloudflair

# go
RUN cd /opt && \
    wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz && \
    tar -xvf go1.13.3.linux-amd64.tar.gz && \
    rm -rf /opt/go1.13.3.linux-amd64.tar.gz && \
    mv go /usr/local
ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}

# gobuster
RUN cd ${HOME}/tools && \
    git clone https://github.com/OJ/gobuster.git && \
    cd gobuster && \
    go get && go install

# virtual-host-discovery
RUN cd ${HOME}/tools && \
    git clone https://github.com/AlexisAhmed/virtual-host-discovery.git && \
    cd virtual-host-discovery && \
    chmod +x scan.rb && \
    ln -sf ${HOME}/tools/virtual-host-discovery/scan.rb /usr/local/bin/virtual-host-discovery

# bucket_finder
RUN cd ${HOME}/tools && \
    git clone https://github.com/AlexisAhmed/bucket_finder.git && \
    cd bucket_finder && \
    chmod +x bucket_finder.rb && \
    ln -sf ${HOME}/tools/bucket_finder/bucket_finder.rb /usr/local/bin/bucket_finder

# dirsearch
RUN cd ${HOME}/tools && \
    git clone https://github.com/AlexisAhmed/dirsearch.git && \
    cd dirsearch && \
    chmod +x dirsearch.py && \
    ln -sf ${HOME}/tools/dirsearch/dirsearch.py /usr/local/bin/dirsearch

# s3recon
RUN pip3 install --upgrade setuptools && \
    pip3 install pyyaml pymongo requests s3recon

# subfinder
RUN go get -v github.com/projectdiscovery/subfinder/cmd/subfinder

# zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&\
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&\
    chsh -s /bin/zsh && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1 && \
    echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

# dotdotpwn
RUN cd ${HOME}/tools && \
    cpanm Net::FTP && \
    cpanm Time::HiRes && \
    cpanm HTTP::Lite && \
    cpanm Switch && \
    cpanm Socket && \
    cpanm IO::Socket && \
    cpanm Getopt::Std && \
    cpanm TFTP && \
    git clone https://github.com/AlexisAhmed/dotdotpwn.git && \
    cd dotdotpwn && \
    chmod +x dotdotpwn.pl && \
    ln -sf ${HOME}/tools/dotdotpwn/dotdotpwn.pl /usr/local/bin/dotdotpwn

# whatweb
RUN cd ${HOME}/tools && \
    git clone https://github.com/urbanadventurer/WhatWeb.git && \
    cd WhatWeb && \
    chmod +x whatweb && \
    ln -sf ${HOME}/tools/WhatWeb/whatweb /usr/local/bin/whatweb

# fierce
RUN python3 -m pip install fierce

# amass
RUN export GO111MODULE=on && \
    go get -v github.com/OWASP/Amass/v3/...
