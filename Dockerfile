FROM resin/armv7hf-node:0.12.2

RUN apt-get update && apt-get install -y \
	bind9 \
	bridge-utils \
	connman \
	iptables \
	libdbus-1-dev \
	libexpat-dev \
	net-tools \
	usbutils \
	wireless-tools	

COPY ./assets/bind /etc/bind

RUN mkdir -p /usr/src/app/
COPY package.json /usr/src/app/
RUN cd /usr/src/app && JOBS=MAX npm install --unsafe-perm --production && npm cache clean

COPY . /usr/src/app
RUN /usr/src/app/node_modules/.bin/coffee -c /usr/src/app/src
RUN chmod +x /usr/src/app/start

VOLUME /var/lib/connman

CMD cd /usr/src/app && ./start
