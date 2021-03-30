SHELL=/bin/bash
PATH:=$(PATH):./node_modules/.bin/
PROJECT=yodaspeak
PORT:=$(shell doppler secrets get PORT --plain)
TLS_PORT:=$(shell doppler secrets get TLS_PORT --plain)

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

# Doppler CLI injects environment variables though the `--env-file` option
docker:
	docker container run \
		--init \
		-d \
		--restart unless-stopped \
		--name yodaspeak \
		--env-file <(doppler secrets download --no-file --format docker) \
		-p $(PORT):$(PORT) \
		-p $(TLS_PORT):$(TLS_PORT) \
		dopplerhq/yodaspeak:latest

# Uses the embedded Doppler CLI by overriding the default CMD (npm start) to be replaced by doppler run -- npm start
# Usage: DOPPLER_TOKEN=dp.st.dev_ryan.XXXX make docker-doppler-cli
docker-doppler-cli:
	docker container run \
		--init \
		-d \
		--restart unless-stopped \
		--name yodaspeak \
		-e DOPPLER_TOKEN=${DOPPLER_TOKEN} \
		-p $(PORT):$(PORT) \
		-p $(TLS_PORT):$(TLS_PORT) \
		dopplerhq/yodaspeak:latest doppler run -- npm start

docker-dev:
	# Runs as root user in order to install dev packages
	docker container run \
		--init \
		--rm \
		-it \
		--name yodaspeak \
		-v $(pwd):/usr/src/app:cached \
		-u root \
		--env-file <(doppler secrets download --no-file --format docker) \
		-p $(PORT):$(PORT) \
		-p $(TLS_PORT):$(TLS_PORT) \
		dopplerhq/yodaspeak:latest ./bin/docker-dev-cmd.sh

docker-stop:
	docker container rm -f yodaspeak

docker-compose-up:
	doppler run -- docker-compose -f docker-compose.yml up;docker-compose rm -fsv;

docker-compose-up-dev:
	doppler run -- docker-compose -f docker-compose.yml -f docker-compose.dev.yml up;docker-compose rm -fsv;

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
