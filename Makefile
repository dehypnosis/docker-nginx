.PHONY: all build release

all:	build

build:
	@docker build --tag=dddpaul/nginx .

release: build
	@docker build --tag=dddpaul/nginx:$(shell cat VERSION) .
