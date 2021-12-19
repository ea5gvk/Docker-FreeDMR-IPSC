FROM debian:bullseye-slim

ENTRYPOINT [ "/entrypoint" ]

RUN useradd -u 54000 radio && \
        apt-get update && \
        apt-get install -y  git gcc g++ python2 python2-dev wget make && \
        cd /opt && \
	wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
	python2 ./get-pip.py && \
	pip install twisted && \
        git clone https://gitlab.hacknix.net/hacknix/DMRlink.git && \
        cd /opt/DMRlink && \
	git checkout IPSC_Bridge && \
        sh ./mk-dmrlink && \
	cd .. && \
	git clone https://gitlab.hacknix.net/hacknix/HBLink.git && \
	cd HBLink && \
	git checkout HB_Bridge && \
	sh ./mk-required && \
	cd .. && \
	git clone https://github.com/g4klx/DMRGateway.git && \
	cd DMRGateway && \
	git reset --hard 6e89e4922f8c5eb7ec3797729a82137d70bc8940 && \
	make && \
	apt-get remove -y  gcc g++ make git wget && \
	apt-get -y autoremove && \
	apt-get -y purge && \
	rm -rvf /var/cache/apt/archives/*  && \
	chown 54000 /opt/* -R && \
        chmod 777 /opt/ -R 


COPY entrypoint /entrypoint
COPY config /opt/
RUN chmod 777 /opt/ -R

USER radio
