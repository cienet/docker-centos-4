FROM scratch

MAINTAINER CIeNET

ADD centos4.7-i386-image.tar.gz /
ADD CentOS-Base.repo /etc/yum.repos.d/

# Fix RPM database error
RUN rm /var/lib/rpm/*
RUN rpm --initdb

ENTRYPOINT ["linux32"]
CMD ["/bin/bash"]
