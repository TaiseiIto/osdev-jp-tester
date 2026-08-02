#!/bin/bash

set -eux

docker_file=Dockerfile
image=image.id
container=container.id

attach_container() {
	docker attach $(< $container)
}

build_image() {
	docker build --iidfile $image $(dirname $docker_file) --build-arg REPOSITORY=$repository --build-arg BRANCH=$branch
}

container_exists() {
	[ -f $container ] && docker inspect $(< $container)
}

container_runs() {
	container_exists && $(docker inspect -f {{.State.Running}} $(< $container)) = true
}

create_container() {
	docker create --interactive --tty $(< $image) /bin/bash > $container
}

image_exists() {
	[ -f $image ] && docker image inspect $(< $image)
}

parse_arguments() {
	while getopts "r:b:" argument; do
		case $argument in
			r) repository=$OPTARG;;
			b) branch=$OPTARG;;
		esac
	done
}

remove_container() {
	docker rm $(< $container)
}

remove_image() {
	docker image rm $(< $image)
	rm $image
}

start_container() {
	docker start $(< $container)
}

stop_container() {
	docker stop $(< $container)
}

parse_arguments $@
container_runs && stop_container
container_exists && remove_container
image_exists && remove_image
image_exists || build_image
container_exists || create_container
container_runs || start_container
attach_container
