#!/bin/bash

set -e

kind create cluster --kubeconfig=../kubeconfig --config kind-config.yaml

export KUBECONFIG=../kubeconfig
kubectl create ns agones-system
kubectl apply -f https://raw.githubusercontent.com/googleforgames/agones/release-1.19.0/install/yaml/install.yaml
kubectl set env -n agones-system deployment/agones-controller FEATURE_GATES="PlayerTracking=true"
kubectl -n agones-system set env deployment/agones-controller MAX_PORT=7020
