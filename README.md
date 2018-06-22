
# Repo analyzer

Small webapp to analyze a repo's git history over time, file per file.

Based on an idea I heard from a talk given by Greg Young, where he claimed
that you could find painpoints in code bases quickly by simply looking
at the git history.


## Installation

This app can be run locally as well as in a Docker image.
The docker image is the easiest way to get up and running.

*NOTE*: currently (22-06-2018) the Docker image doesn't work that great on MacOSX due to extremely slow docker volumes.
On Linux, everything is buttery smooth. :sweat_smile:

If you do want to run it on MacOSX, it's probably best to run it directly.


### Based on image from Dockerhub

1. docker pull luctielen/repo_analyzer
2. docker run -p 80:8000 -v /path/to/repository:/app/repo:ro,cached -it repo_analyzer


### Locally building Docker image

The `Makefile` in this repo has some shortcuts for executing the correct docker commands:

1. make build
2. make run
3. Open your browser (http://127.0.0.1)

If you want to analyze another repo than this one, take a look at the run command in the Makefile and change `$(pwd)` to another directory containing a git repository.


### Running repo_analyzer directly (no Docker)

This can be done as follows:

1. Install cargo, rust (nightly 2018-06-09), yarn
2. cd backend && cargo build --release && cargo install && cd -
3. cd frontend && yarn install && yarn run elm-package install -- -y && yarn run elm-make Main.elm -- --output=frontend/static/js/app.js && cd -
4. ROCKET_PORT=80 REPO_DIR=/path/to/repo/you/want/to/analyze repo_analyzer
5. Open browser (http://127.0.0.1)

