# Setting the base to docker-node-unoconv
FROM telemark/docker-node-unoconv:10.14.0

RUN wget -O /etc/apt/sources.list http://mirrors.cloud.tencent.com/repo/ubuntu16_sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
RUN apt-get update
# RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
# RUN apt install -y ttf-mscorefonts-installer
RUN apt-get install fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-arphic-ukai fonts-arphic-uming fonts-cns11643-kai fonts-cns11643-sung fonts-cwtex-fs fonts-cwtex-heib fonts-cwtex-kai fonts-cwtex-ming fonts-cwtex-yen
RUN wget -O /usr/share/fonts/simsun.ttc https://github.com/sonatype/maven-guide-zh/raw/master/content-zh/src/main/resources/fonts/simsun.ttc
RUN wget -O /usr/share/fonts/SimHei.ttf https://github.com/StellarCN/scp_zh/raw/master/fonts/SimHei.ttf
RUN chmod 644 /usr/share/fonts/simsun.ttc
RUN chmod 644 /usr/share/fonts/SimHei.ttf
RUN fc-cache -f -v

# Clone the repo
RUN git clone https://github.com/zrrrzzt/tfk-api-unoconv.git unoconvservice

# Change working directory
WORKDIR /unoconvservice

# Install dependencies
RUN npm install --production

# Env variables
ENV SERVER_PORT 3000
ENV PAYLOAD_MAX_SIZE 1048576
ENV TIMEOUT_SERVER 120000
ENV TIMEOUT_SOCKET 140000

# Expose 3000
EXPOSE 3000

# Startup
ENTRYPOINT /usr/bin/unoconv --listener --server=0.0.0.0 --port=2002 & node standalone.js
