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

docker-build:
	docker image build -t dopplerhq/yodaspeak:latest .

docker-buildx:
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build -t dopplerhq/yodaspeak:latest .

# Needs `DOPPLER_TOKEN` env var to fetch secrets from Doppler's API
# Learn more at https://docs.doppler.com/docs/enclave-service-tokens
docker-run:
	docker container run -it --rm -e DOPPLER_TOKEN=$(DOPPLER_TOKEN) -p 3000:3000 dopplerhq/yodaspeak:latest


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

	$(MAKE) heroku-deploy API_KEY=$(API_KEY)

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

heroku-deploy:
	git push $(HEROKU_APP) master -f
	heroku open --app $(HEROKU_APP)

heroku-clear-doppler-vars:
	heroku config:unset --app $(HEROKU_APP) DOPPLER_ENCLAVE_CONFIG DOPPLER_CONFIG DOPPLER_ENCLAVE_ENVIRONMENT DOPPLER_ENVIRONMENT DOPPLER_ENCLAVE_PROJECT DOPPLER_PROJECT

heroku-destroy:
	heroku domains:clear --app $(HEROKU_APP)
	heroku apps:destroy --app $(HEROKU_APP) --confirm $(HEROKU_APP)
