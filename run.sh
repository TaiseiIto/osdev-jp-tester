#!/bin/bash

set -eux

docker_file=Dockerfile
image=image.id

build_image() {
	docker build --iidfile $1 $(dirname $2)
}

image_exists() {
	[ -f $image ] && docker image inspect $(< $1)
}

image_exists $image || build_image $image $docker_file
