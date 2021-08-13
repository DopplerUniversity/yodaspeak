SHELL=/bin/bash
PATH:=$(PATH):./node_modules/.bin/
PROJECT=yodaspeak


#################
#  DEVELOPMENT  #
#################

server:
	doppler run -- npm start

dev-server:
	doppler run -- nodemon npm start

static-server:
	doppler run -- npm run build
	python3 -m http.server --directory ./dist

devcontainer-doppler-token:
	@echo "DOPPLER_TOKEN=$(shell doppler configure get token --plain)" > .devcontainer/.env
	@echo "DOPPLER_PROJECT=$(shell doppler configure get project --plain)" >> .devcontainer/.env
	@echo "DOPPLER_CONFIG=$(shell doppler configure get config --plain)" >> .devcontainer/.env

devcontainer-env-file:
	doppler secrets download --no-file --format docker > .devcontainer/.env


############
#  Docker  #
############

CONTAINER_NAME=yodaspeak
IMAGE_NAME=doppleruniversity/yodaspeak

docker-build:
	docker image build -t $(IMAGE_NAME):latest .

docker-buildx:
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build -t $(IMAGE_NAME):latest .

# Doppler CLI injects environment variables though the `--env-file` option
docker:
	docker container run \
		-d \
		--restart unless-stopped \
		--name yodaspeak \
		--env-file <(doppler secrets download --no-file --format docker) \
		-p 8080:8080 \
		-p 8443:8443 \
		doppleruniversity/yodaspeak:latest

# Uses the embedded Doppler CLI by overriding the default CMD (npm start) to be replaced by doppler run -- npm start
# Usage: DOPPLER_TOKEN=dp.st.dev_ryan.XXXX make docker-doppler-cli
docker-doppler-cli:
	docker container run \
		-d \
		--restart unless-stopped \
		--name yodaspeak \
		-e DOPPLER_TOKEN=${DOPPLER_TOKEN} \
		-p 8080:8080 \
		-p 8443:8443 \
		doppleruniversity/yodaspeak:latest

# Runs as root user in order to install dev packages
docker-dev:
	docker container run \
		--rm \
		-it \
		--name yodaspeak \
		-v $(shell pwd):/usr/src/app:cached \
		-u root \
		--env-file <(doppler secrets download --no-file --format docker) \
		-p 8080:8080 \
		doppleruniversity/yodaspeak:latest

docker-stop:
	docker container rm -f yodaspeak

docker-compose:
	doppler run -- docker-compose -f docker-compose.yml up;docker-compose rm -fsv;

docker-compose-dev:
	doppler run -- docker-compose -f docker-compose.yml -f docker-compose.dev.yml up;docker-compose rm -fsv;

docker-compose-cli:
	DOPPLER_TOKEN=$(shell doppler configure get token --plain) DOPPLER_PROJECT=$(shell doppler configure get project --plain) DOPPLER_CONFIG=$(shell doppler configure get config --plain) docker-compose -f docker-compose.yml -f docker-compose.dev-cli.yml up;docker-compose rm -fsv;

docker-compose-dev-cli:
	doppler run -- docker-compose -f docker-compose.yml -f docker-compose.dev-cli.yml up;docker-compose rm -fsv;

docker-shell:
	docker container exec -it $(CONTAINER_NAME) sh


##############
# KUBERNETES #
##############
#kubectl create secret generic doppler-token --from-literal=DOPPLER_TOKEN=${DOPPLER_TOKEN}
k8s-deploy:
	kubectl apply -f kubernetes/deployment.yml

# k8s-remove:


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
