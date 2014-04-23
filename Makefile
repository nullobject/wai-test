build: clean components
	@component build

components: component.json
	@component install

clean:
	rm -rf build components

server: build
	@cabal run

.PHONY: clean
