SHELL := /bin/bash
export KUBECONFIG=./kubeconfig

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-clients: ## Builds clients for linux, windows and mac
	@docker build -t godot-client-builder -f game-client/Dockerfile game-client/
	@docker run -v ${PWD}/game-client/:/data/ godot-client-builder --path /data/ --export --quiet windows /data/builds/windows/game.exe
	@docker run -v ${PWD}/game-client/:/data/ godot-client-builder --path /data/ --export --quiet osx /data/builds/mac/game.zip
	@docker run -v ${PWD}/game-client/:/data/ godot-client-builder --path /data/ --export --quiet linux /data/builds/linux/game.x86_64

cluster: ## Boostraps a local kind cluster
	@kind create cluster --kubeconfig=kubeconfig --config infra/kind-config.yaml
	@kubectl create ns agones-system
	@kubectl apply -f https://raw.githubusercontent.com/googleforgames/agones/release-1.19.0/install/yaml/install.yaml
	@kubectl set env -n agones-system deployment/agones-controller FEATURE_GATES="PlayerTracking=true"
	@kubectl -n agones-system set env deployment/agones-controller MAX_PORT=7020

deploy-server: ## Build and deploy game servers
	@docker build -t godot-game-server -f game-server/Dockerfile game-server/
	@kind load docker-image godot-game-server --name agones-broadcaster-http
	@@kubectl -n agones-system wait --for=condition=ready pod -l app=agones
	@kubectl apply -f game-server/fleet.yaml

install-broadcaster:## Installs Octops Boradcaster
	@kubectl apply -f https://raw.githubusercontent.com/Octops/agones-broadcaster-http/main/install/install.yaml
	@kubectl patch svc agones-broadcaster-http --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"},{"op":"replace","path":"/spec/ports/0/nodePort","value":30000}]'

start: cluster install-broadcaster deploy-server

destroy:
	@kind delete cluster --name agones-broadcaster-http