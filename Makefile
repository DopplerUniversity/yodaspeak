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


################
#  PRODUCTION  #
################

# Prod server - persistent background process without process manager or Docker
# Uses sudo to bind to port 80 and/or 443

prod-server-up:
	@sudo nohup doppler run -- npm start >/dev/null 2>&1 &

prod-server-down:
	-@sudo kill $(shell pgrep node) >/dev/null 2>&1

prod-server-restart: prod-server-down prod-server-up


############
#  Docker  #
############

CONTAINER_NAME=yodaspeak
IMAGE_NAME=dopplerhq/yodaspeak

docker-build:
	docker image build -t $(IMAGE_NAME):latest .

docker-buildx:
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build -t $(IMAGE_NAME):latest .

docker-run:
	docker container run \
		-it \
		--rm \
		--init \
		--name $(CONTAINER_NAME) \
		-e DOPPLER_TOKEN=${YODASPEAK_SERVICE_TOKEN} \
		-p 8080:8080 \
		-p 8443:8443 \
		$(IMAGE_NAME):latest

docker-compose-up:
	docker-compose up

docker-compose-dev:
	DOPPLER_TOKEN="$(shell doppler configure get token --plain)" \
	DOPPLER_PROJECT="$(shell doppler configure get project --plain)" \
	DOPPLER_CONFIG="$(shell doppler configure get config --plain)" \
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up; docker-compose rm -fsv

# Required to install dev dependencies
docker-run-dev:
	docker container run \
		-it \
		--init \
		--name $(CONTAINER_NAME) \
		--rm \
		-e "DOPPLER_TOKEN=$(shell doppler configure get token --plain)" \
		-e "DOPPLER_PROJECT=$(shell doppler configure get project --plain)" \
		-e "DOPPLER_CONFIG=$(shell doppler configure get config --plain)" \
		-v $(shell pwd):/usr/src/app:cached \
		-u root \
		-p 8443:8443 \
		-p 8080:8080 \
		$(IMAGE_NAME):latest \
		./bin/docker-dev-command.sh

docker-shell:
	docker container exec -it $(CONTAINER_NAME) sh


###############
#  UTILITIES  #
###############

code-clean:
	npm run format
	npm run lint


############
#  HEROKU  #
############

# Used by Doppler for integration testing

HEROKU_TEAM=dagobah-systems
HEROKU_APP=yodaspeak-production

heroku-create:
	heroku apps:create --team $(HEROKU_TEAM) $(HEROKU_APP)

	$(MAKE) heroku-set-vars API_KEY=$(API_KEY)

	heroku domains:add --app $(HEROKU_APP) yodaspeak.io
	heroku domains:wait --app $(HEROKU_APP) yodaspeak.io
	git remote rename heroku $(HEROKU_APP)

	$(MAKE) heroku-deploy

heroku-set-vars:
	heroku config:set --app $(HEROKU_APP) \
	DEBUG="yodaspeak:*" \
	HOSTNAME="0.0.0.0" \
	LOGGING="common" \
	NODE_ENV="production" \
	TRANSLATION_SUGGESTION="Secrets must not be stored in git repositories" \
	YODA_TRANSLATE_API_ENDPOINT="https://api.funtranslations.com/translate/yoda.json" \
	YODA_TRANSLATE_API_KEY="$(API_KEY)" \
	RATE_LIMITING_ENABLED="true" \
	NPM_CONFIG_PRODUCTION="true"

heroku-get-vars:
	heroku config --json -a $(HEROKU_APP)

heroku-deploy:
	git push $(HEROKU_APP) master -f
	heroku open --app $(HEROKU_APP)

heroku-clear-doppler-vars:
	heroku config:unset --app $(HEROKU_APP) DOPPLER_ENCLAVE_CONFIG DOPPLER_CONFIG DOPPLER_ENCLAVE_ENVIRONMENT DOPPLER_ENVIRONMENT DOPPLER_ENCLAVE_PROJECT DOPPLER_PROJECT

heroku-destroy:
	heroku domains:clear --app $(HEROKU_APP)
	heroku apps:destroy --app $(HEROKU_APP) --confirm $(HEROKU_APP)
