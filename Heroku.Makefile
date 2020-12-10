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
