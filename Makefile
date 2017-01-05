default: build

VERSION := $(shell date "+%Y%m%d").0
DEPLOY_SERVER := cienet@10.60.19.70

build:
	docker build -t cienet/centos-4-dev:$(VERSION) . \
	    -f dev/Dockerfile

save:
	docker save -o ../images/camp-civi-$(VERSION).tar camp/civi:$(VERSION)

deploy: fix_key_perm
	scp -i ../support/rsa/camp.key ../images/camp-civi-$(VERSION).tar $(DEPLOY_SERVER):
	ssh -i ../support/rsa/camp.key $(DEPLOY_SERVER) "docker load -i camp-civi-$(VERSION).tar"
	ssh -i ../support/rsa/camp.key $(DEPLOY_SERVER) "docker tag camp/civi:$(VERSION) camp/civi"

ssh: fix_key_perm
	ssh -i ../support/rsa/camp.key $(DEPLOY_SERVER)

trigger:
	source .env && \
	curl -X POST \
         -F token=$$CAMPCI_TOKEN \
		 http://ci.camp.cienetcorp.com/api/v1/projects/8/refs/release-daily/trigger

fix_key_perm:
	chmod 600 ../support/rsa/camp.key
