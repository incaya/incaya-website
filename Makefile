help: # Display available commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

pre-start:
	docker build -t incaya-website .
start: pre-start ## Lancement de hugo en mode dev
	docker run --rm --name incaya-local-website \
	  -v $(shell pwd):/website \
	  -w /website \
	  -p 1313:1313 \
	  incaya-website

build: pre-start ## Génération des statiques finaux
	docker run --rm --name incaya-local-website \
	  -v $(shell pwd):/website \
	  -w /website \
	  -p 1313:1313 \
	  incaya-website \
	  ash -ci hugo

.PHONY: pre-start start
