FROM centos:centos7

MAINTAINER Vaclav Pavlin <vpavlin@redhat.com>

RUN echo -e "[epel]\nname=epel\nenabled=1\nbaseurl=https://dl.fedoraproject.org/pub/epel/7/x86_64/\ngpgcheck=0" > /etc/yum.repos.d/epel.repo

RUN yum install -y --setopt=tsflags=nodocs python-pip docker && \
    yum clean all

ADD atomicapp/ /opt/atomicapp/atomicapp/
ADD setup.py /opt/atomicapp/
ADD requirements.txt /opt/atomicapp/

WORKDIR /opt/atomicapp

RUN pip install .

WORKDIR /atomicapp

ONBUILD ADD . /application-entity/
ONBUILD ADD /artifacts /application-entity/artifacts

LABEL RUN docker run -it --rm --privileged --net=host -v /run:/run -v /:/host --name NAME -e NAME=NAME -e IMAGE=IMAGE IMAGE -v run /atomicapp
LABEL STOP docker run -it --rm --privileged --net=host -v /run:/run -v /:/host --name NAME -e NAME=NAME -e IMAGE=IMAGE IMAGE -v stop /atomicapp
LABEL INSTALL docker run -it --rm --privileged --net=host -v /run:/run -v /:/host --name NAME -e NAME=NAME -e IMAGE=IMAGE IMAGE -v install --path /atomicapp /application-entity

ENTRYPOINT ["/usr/bin/atomicapp"]

