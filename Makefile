PATH:=$(PATH):./node_modules/.bin/
PROJECT=yodaspeak


## Dev server

server:
	doppler run -- npm start

dev-server:
	doppler run -- nodemon npm start

static-server:
	doppler run -- npm run build
	python3 -m http.server --directory ./dist

# Prod server - persistent background process without process manager or Docker
# Uses sudo to bind to port 80 and/or 443

# # Docker

docker-build:
	docker image build -t dopplerhq/yodaspeak:latest .

# Needs `DOPPLER_TOKEN` env var to fetch secrets from Doppler's API
# Learn more at https://docs.doppler.com/docs/enclave-service-tokens
docker-run:
	docker container run -it --rm -e DOPPLER_TOKEN=$(DOPPLER_TOKEN) -p 3000:3000 dopplerhq/yodaspeak:latest

docker-push: docker-build
	docker image push dopplerhq/yodaspeak

prod-server-up:
	@sudo nohup doppler run -- npm start >/dev/null 2>&1 &

prod-server-down:
	-@sudo kill $(shell pgrep node) >/dev/null 2>&1

prod-server-restart: prod-server-down prod-server-up


### Utilities

code-clean:
	npm run format
	npm run lint
