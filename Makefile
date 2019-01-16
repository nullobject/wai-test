.PHONY: build clean start watch

build:
	@stack build
	@npx parcel build static/index.html

start: build
	@stack run

watch:
	@npx parcel watch static/index.html

clean:
	@rm -rf dist
