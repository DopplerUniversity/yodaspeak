PROJECT=yodaspeak
HEROKU_TEAM=dagobah
HEROKU_APP_PRODUCTION=yodaspeak-production

# This is for the Doppler team to use, but you can adapt to deploy under your own Heroku account

heroku-create:
	heroku apps:create --team $(HEROKU_TEAM) $(HEROKU_APP_PRODUCTION)

	$(MAKE) heroku-set-vars API_KEY=$(API_KEY)

	heroku domains:add --app $(HEROKU_APP_PRODUCTION) yodaspeak.io
	heroku domains:wait --app $(HEROKU_APP_PRODUCTION) yodaspeak.io
	git remote rename heroku $(HEROKU_APP_PRODUCTION)

heroku-set-vars:
	heroku config:set --app $(HEROKU_APP_PRODUCTION) \
	DEBUG="yodaspeak:*" \
	HOSTNAME="0.0.0.0" \
	LOGGING="common" \
	NODE_ENV="production" \
	TRANSLATION_SUGGESTION="Secrets must not be stored in git repositories" \
	YODA_TRANSLATE_API_ENDPOINT="https://api.funtranslations.com/translate/yoda.json" \
	YODA_TRANSLATE_API_KEY="$(API_KEY)"

heroku-deploy:
	git push $(HEROKU_APP_PRODUCTION) master -f
	heroku open --app $(HEROKU_APP_PRODUCTION)
	open https://yodaspeak.io

heroku-clear-doppler-vars:
	heroku config:unset --app $(HEROKU_APP_PRODUCTION) DOPPLER_ENCLAVE_CONFIG DOPPLER_CONFIG DOPPLER_ENCLAVE_ENVIRONMENT DOPPLER_ENVIRONMENT DOPPLER_ENCLAVE_PROJECT DOPPLER_PROJECT

heroku-destroy:
	heroku domains:clear --app $(HEROKU_APP_PRODUCTION)
	heroku apps:destroy --app $(HEROKU_APP_PRODUCTION) --confirm $(HEROKU_APP_PRODUCTION)

doppler-reset:heroku-clear-doppler-vars
	-doppler projects delete --project $(PROJECT) -y
	-doppler logout -y
	-rm -fr ~/.doppler
	-cp sample.env .env
