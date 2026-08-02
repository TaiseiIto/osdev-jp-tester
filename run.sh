#!/bin/bash

set -eux

docker_file=Dockerfile
image=image.id
container=container.id
port=4000

attach_container() {
	docker attach $(< $container)
}

build_image() {
	docker build --iidfile $image $(dirname $docker_file) --build-arg REPOSITORY=$repository --build-arg BRANCH=$branch --build-arg PORT=$port
}

container_exists() {
	[ -f $container ] && docker inspect $(< $container)
}

container_runs() {
	container_exists && $(docker inspect -f {{.State.Running}} $(< $container)) = true
}

create_container() {
	docker create --interactive --tty $(docker image inspect $(< $image) --format='{{range $port, $_ := .Config.ExposedPorts}}{{$port}} {{end}}' | cut -d '/' -f 1 | while read -r port; do echo --publish $port:$port; done | tr '\n' ' ') $(< $image) /bin/bash > $container
}

image_exists() {
	[ -f $image ] && docker image inspect $(< $image)
}

main() {
	parse_arguments $@
	container_runs && stop_container
	container_exists && remove_container
	image_exists && remove_image
	image_exists || build_image
	container_exists || create_container
	container_runs || start_container
	start_server
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

start_server() {
	docker exec --interactive --tty $(< $container) bundle exec jekyll serve --host 0.0.0.0 --port $port
}

stop_container() {
	docker stop $(< $container)
}

main $@
