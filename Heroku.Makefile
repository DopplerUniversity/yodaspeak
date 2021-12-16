############
#  HEROKU  #
############

# Used by Doppler for integration testing

TEAM=dopplerhq
APP=yodaspeak-production
DOMAIN=yodaspeak.io

create:
	heroku apps:create --team $(TEAM) $(APP)

	$(MAKE) set-vars -f Heroku.Makefile API_KEY=$(API_KEY) TEAM=$(APP)

	heroku domains:add --app $(APP) $(DOMAIN)
	heroku domains:wait --app $(APP) $(DOMAIN)
	git remote rename heroku $(APP)

	$(MAKE) deploy -f Heroku.Makefile APP=$(APP)

set-vars:
	heroku config:set --app $(APP) \
	DEBUG="yodaspeak:*" \
	HOSTNAME="0.0.0.0" \
	LOGGING="common" \
	NODE_ENV="production" \
	TRANSLATION_SUGGESTION="Secrets must not be stored in git repositories" \
	YODA_TRANSLATE_API_ENDPOINT="https://api.funtranslations.com/translate/yoda.json" \
	YODA_TRANSLATE_API_KEY="$(API_KEY)" \
	RATE_LIMITING_ENABLED="true" \
	NPM_CONFIG_PRODUCTION="true"

get-vars:
	heroku config --json -a $(APP)

deploy:
	git push $(APP) master -f
	heroku open --app $(APP)

logs:
	heroku logs --app $(APP) --tail

clear-doppler-vars:
	heroku config:unset --app $(APP) DOPPLER_ENCLAVE_CONFIG DOPPLER_CONFIG DOPPLER_ENCLAVE_ENVIRONMENT DOPPLER_ENVIRONMENT DOPPLER_ENCLAVE_PROJECT DOPPLER_PROJECT

destroy:
	heroku domains:clear --app $(APP)
	heroku apps:destroy --app $(APP) --confirm $(APP)
