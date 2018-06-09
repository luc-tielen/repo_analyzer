
build:
	cargo build
	brunch build

test:
	cargo test

live_reload:
	npm run watch

.PHONY: build test live_reload
