FROM centos:stream8
MAINTAINER Alberto Losada
ARG NC_PORT=7000
ENV PORT=$NC_PORT

USER root
RUN dnf -y install bind-utils openssh-clients iproute nc wget telnet \ 
                   ethtool tcpdump net-tools sysstat perf strace tcpdump \
                   dmidecode lshw numactl ipmitool iperf3 traceroute python3 && \
		   dnf clean all && rm -rf /var/cache/dnf

RUN wget -O /usr/local/bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py && \
    chmod +x /usr/local/bin/speedtest-cli && \
    alternatives --set python /usr/bin/python3 

#USER 3050
#ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/nc -v -klp ${PORT}"]
ENTRYPOINT ["/bin/bash"]
#EXPOSE ${PORT}
