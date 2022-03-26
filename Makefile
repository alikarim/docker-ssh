SHELL=/bin/bash

usage=make <target> account=<docker account> image=<docker image> tag=<docker tag>

include .env

ifndef account
override account = default_account
endif

ifndef image
override image = default_image_name
endif

ifndef tag
override tag = latest
endif

ifndef port
override port = 22
endif

build:
	docker build \
		--build-arg port="$(port)" \
		--no-cache=true -t $(image) .

tag:
	docker tag $(image) $(account)/$(image):$(tag)

push: tag
	docker push $(account)/$(image):$(tag)

run:
	docker run -it -p $(port):$(port) $(image) bash

ssh: clean
	mkdir -p ssh
	ssh-keygen -t rsa -b 4096 -C "$(email)" -f ./ssh/id_rsa -q -N ""
	chmod 400 ./ssh/id_rsa

clean:
	rm -rf ssh/id_rsa*
