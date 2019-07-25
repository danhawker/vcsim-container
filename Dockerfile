FROM registry.redhat.io/ubi8/ubi as go_builder

RUN mkdir "/root/gopath"

WORKDIR /root/gopath

RUN yum -y install --disableplugin=subscription-manager golang git; \
	yum  --disableplugin=subscription-manager clean all; \
	rm -rf /var/cache/yum

RUN go get -u github.com/vmware/govmomi/vcsim


FROM registry.redhat.io/ubi8/ubi-init

RUN mkdir /app

WORKDIR /app

COPY --from=go_builder /root/go/bin/vcsim /app/
RUN chmod +x /app/vcsim
ADD vcsim.service /etc/systemd/system/vcsim.service

RUN systemctl enable vcsim; systemctl enable vcsim

EXPOSE 8989

CMD [ "/sbin/init" ]
