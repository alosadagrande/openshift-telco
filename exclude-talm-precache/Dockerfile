FROM registry.access.redhat.com/ubi9/python-311

ENV KUBECONFIG="/tmp/kubeconfig"

COPY kcs.py /usr/bin/kcs.py
COPY init.sh /usr/bin/init.sh

WORKDIR /tmp

RUN curl https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz -o /tmp/oc.tgz && \
    tar zxvf /tmp/oc.tgz oc && \
    chmod u+x /tmp/oc && \
    pip install openshift && \
    mkdir assets && \
    rm -f /tmp/oc.tgz

USER 0
RUN dnf install jq -y && \
    dnf clean all  && rm -rf /var/cache/dnf 


ENTRYPOINT ["/bin/bash", "/usr/bin/init.sh"]
