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

prod-server-up:
	@sudo nohup doppler run -- npm start >/dev/null 2>&1 &

prod-server-down:
	-@sudo kill $(shell pgrep node) >/dev/null 2>&1

prod-server-restart: prod-server-down prod-server-up


### Utilities

code-clean:
	npm run format
	npm run lint
