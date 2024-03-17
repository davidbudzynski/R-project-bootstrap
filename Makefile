CURRENT_DIR := $(shell pwd)
CURRENT_DIR_BASENAME := $(shell basename $(CURRENT_DIR))
DOCKER_RELEASE_TAG := latest# assume latest tag is the default
# the image name should be lowercase, so convert the current directory name to
# lowercase
DOCKER_IMAGE_NAME := $(shell echo $(CURRENT_DIR_BASENAME) | tr '[:upper:]' '[:lower:]')

.PHONY: clean docker-build docker-run docker-save-image docker-load-image

clean: # remove all files in output directory

	rm -rf output/plots/*
	touch output/plots/.gitkeep
	rm -rf output/reports/*
	touch output/reports/.gitkeep
	rm -rf output/data/*
	touch output/data/.gitkeep
	rm -rf $(DOCKER_IMAGE_NAME)-$(DOCKER_RELEASE_TAG).tar.zst

docker-build: # build docker image
	docker build \
		--tag $(DOCKER_IMAGE_NAME):$(DOCKER_RELEASE_TAG) \
		--file Dockerfile \
		.

docker-run: # run docker image
	docker run --rm \
		--interactive \
		--tty \
		--volume $(CURRENT_DIR):/home/$(CURRENT_DIR_BASENAME)/ \
		--workdir /home/$(CURRENT_DIR_BASENAME)/ \
		$(DOCKER_IMAGE_NAME):$(DOCKER_RELEASE_TAG) \
