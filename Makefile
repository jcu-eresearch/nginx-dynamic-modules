all:
	docker-compose up

test:
	docker-compose run -p "8080:80" centos-7 bash

build:
	docker pull centos:7 && docker pull centos:6
	docker-compose build

clean:
	docker-compose down --volumes --remove-orphans
	rm -rf build/centos-*/*

ci:
	docker-compose up --build

.PHONY: all test build clean ci
