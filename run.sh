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

parse_arguments() {
	while getopts "r:b:" argument; do
		case $argument in
			r) repository=$OPTARG;;
			b) branch=$OPTARG;;
		esac
	done
}

remove_image() {
	docker image rm $(< $1)
	rm $1
}

parse_arguments $@
echo $repository
echo $branch
image_exists $image && remove_image $image
image_exists $image || build_image $image $docker_file
