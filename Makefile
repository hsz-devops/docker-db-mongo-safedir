# v1.0.0    2016-06-20     webmaster@highskillz.com

IMAGE_NAME=ez123/db-mongo-safedir

THIS_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TIMESTAMP=$(shell date -u +"%Y%m%d_%H%M%S%Z")

BUILD_OPTS=--pull --force-rm
#BUILD_OPTS=--force-rm

# --------------------------------------------------------------------------
default: build

# --------------------------------------------------------------------------
build: _DOCKER_BUILD_OPTS=$(BUILD_OPTS)
build: _build_image

rebuild: _DOCKER_BUILD_OPTS=--no-cache $(BUILD_OPTS)
rebuild: _build_image

_build_image: _check-env-base
	docker build $(_DOCKER_BUILD_OPTS) -t $(IMAGE_NAME):3.2     ./3.2-safedir
	docker build $(_DOCKER_BUILD_OPTS) -t $(IMAGE_NAME):3.6     ./3.6-safedir

# --------------------------------------------------------------------------
_check-env-base:
	test -n "$(TIMESTAMP)"
	#test -n "$(TAG_NAME)"

# --------------------------------------------------------------------------
shell:shell-32

shell-32: _check-env-base
	docker run --rm -it $(IMAGE_NAME):3.2     bash

shell-36: _check-env-base
	docker run --rm -it $(IMAGE_NAME):3.6     bash

# --------------------------------------------------------------------------
rmi: _check-env-base
	docker rmi $(IMAGE_NAME):3.2
	docker rmi $(IMAGE_NAME):3.6

# --------------------------------------------------------------------------
clean-junk:
	docker rm        `docker ps -aq -f status=exited`      || true
	docker rmi       `docker images -q -f dangling=true`   || true
	docker volume rm `docker volume ls -qf dangling=true`  || true

# --------------------------------------------------------------------------
list:
	docker images
	docker volume ls
	docker ps -a
