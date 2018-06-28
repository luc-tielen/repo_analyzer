
build:
	docker build . -t repo_analyzer

run:
	docker run -p 80:8000 -p 8000:8000 -v $(shell pwd):/app/repo:ro,cached -it repo_analyzer

.PHONY: build run
