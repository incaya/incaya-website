help: # Display available commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

start: ## Lancement de hugo en mode dev
	docker run --rm --name incaya-local-website \
	  -v $(shell pwd):/website \
	  -w /website \
	  -p 1313:1313 \
	  ghcr.io/incaya/incaya-website:latest

build: ## Génération des statiques finaux
	docker run --rm --name incaya-local-website \
	  -v $(shell pwd):/website \
	  -w /website \
	  -p 1313:1313 \
	  ghcr.io/incaya/incaya-website:latest \
	  ash -ci hugo

docker-image: ## construction et publication de l'image Docker Hugo
	docker build -t incaya-website --force-rm .
	docker tag incaya-website ghcr.io/incaya/incaya-website:latest
	docker tag incaya-website ghcr.io/incaya/incaya-website:0.93.0
	docker push ghcr.io/incaya/incaya-website:0.93.0
	docker push ghcr.io/incaya/incaya-website:latest
	

.PHONY: start build docker-image
