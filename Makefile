SHELL=/bin/bash
PATH:=$(PATH):./node_modules/.bin/
PROJECT=yodaspeak

################
#  DEV SERVER  #
################

server:
	doppler run -- npm start

dev-server:
	doppler run -- nodemon npm start

static-server:
	doppler run -- npm run build
	python3 -m http.server --directory ./dist


############
#  Docker  #
############

CONTAINER_NAME=yodaspeak
IMAGE_NAME=dopplerhq/yodaspeak

docker-build:
	docker image build -t $(IMAGE_NAME):latest .

docker-buildx:
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build -t $(IMAGE_NAME):latest .

docker:
	./bin/docker.sh

docker-dev:
	./bin/docker-dev.sh

docker-doppler:
	./bin/docker-doppler.sh

docker-stop:
	docker container rm -f yodaspeak

docker-compose-up:
	./bin/docker-compose-up.sh

docker-compose-up-dev:
	./bin/docker-compose-up-dev.sh

docker-shell:
	docker container exec -it $(CONTAINER_NAME) sh


###############
#  UTILITIES  #
###############

doppler-project-setup:
	@echo '[info]: Creating "yodaspeak" project'
	doppler projects create yodaspeak
	doppler setup
	@echo '[info]: Uploading default secrets'
	doppler secrets upload sample.env
	@echo '[info]: Viewing secrets'
	doppler secrets download --no-file --format env
	@echo '[info]: For HTTPS, create the `TLS_CERT`, `TLS_KEY`, and `TLS_PORT` secrets'


code-clean:
	npm run format
	npm run lint
