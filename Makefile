
build:
	docker build . -t ra

run:
	docker run -p 80:8000 -v $(shell pwd):/app/repo -it ra

.PHONY: build run
