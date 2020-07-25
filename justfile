build: clean
	#!/usr/bin/env sh
	jpm deps
	jpm build
	mkdir -p bin
	mv build/pull-all bin/pull-all.{{os()}}.{{arch()}}
	gzip bin/pull-all.{{os()}}.{{arch()}}

clean:
	rm -rf build/*
	mkdir -p build

build-linux:
	docker build -t pull-all .
	docker run -it --rm -v "$PWD:/pull-all" -w '/pull-all' --entrypoint="just" pull-all:latest build
