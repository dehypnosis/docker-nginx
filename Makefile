all: build

build:
	@docker build --tag=smile/nginx .

release: build
	@docker build --tag=smile/nginx:$(shell cat VERSION) .
