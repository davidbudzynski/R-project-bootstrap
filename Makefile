CURRENT_DIR := $(shell pwd)
CURRENT_DIR_BASENAME := $(shell basename $(CURRENT_DIR))
DOCKER_RELEASE_TAG := latest# assume latest tag is the default
# the image name should be lowercase, so convert the current directory name to
# lowercase
DOCKER_IMAGE_NAME := $(shell echo $(CURRENT_DIR_BASENAME) | tr '[:upper:]' '[:lower:]')

.PHONY: clean docker-build docker-run docker-save-image docker-load-image init

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
		$(DOCKER_IMAGE_NAME):$(DOCKER_RELEASE_TAG)

docker-save-image:
	docker save \$(DOCKER_IMAGE_NAME):$(DOCKER_RELEASE_TAG) \
		| zstd -19 -T0 > $(DOCKER_IMAGE_NAME)-$(DOCKER_RELEASE_TAG).tar.zst

# load the image from the compressed archive. This is useful for sharing the
# built image but probably not likely that you will need to do this. more info
# at:
# https://raps-with-r.dev/repro_cont.html?q=docker%20sav#sharing-a-compressed-archive-of-your-image
docker-load-image:
	zstd -d -c $(DOCKER_IMAGE_NAME)-$(DOCKER_RELEASE_TAG).tar.zst | docker load

init: # initialize the project
	mv rstudio_project_template.Rproj $(CURRENT_DIR_BASENAME).Rproj

# TODO: add a target to run code formatting and linting
# TODO: add a target to run the main analysis
