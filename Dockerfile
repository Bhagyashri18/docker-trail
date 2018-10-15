FROM centos:7

# Systemd enable by official documentation: https://hub.docker.com/_/centos/
ADD https://raw.githubusercontent.com/maci0/docker-systemd-unpriv/master/dbus.service /etc/systemd/system/dbus.service

ENV container docker
RUN yum -y install systemd systemd-libs dbus && \
    systemctl mask dev-mqueue.mount dev-hugepages.mount systemd-remount-fs.service sys-kernel-config.mount \
        sys-kernel-debug.mount sys-fs-fuse-connections.mount display-manager.service graphical.target systemd-logind.service && \
    yum -y install tomcat tomcat-native && \
        systemctl enable tomcat && \
            sed -i 's#<Connector port="8080" protocol="HTTP/1.1"#<Connector port="8080" protocol="HTTP/1.1" URIEncoding="UTF-8"#' /etc/tomcat/server.xml && \
        systemctl enable dbus.service && \
            chmod 0644 /etc/systemd/system/dbus.service && \
    yum clean all

RUN yum -y install initscripts && \
    yum install net-tools -y

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]

#? CMD ["/usr/lib/systemd/systemd"]
CMD ["/usr/sbin/init"]
