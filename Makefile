# Image URL to use all building/pushing image targets;
DOCKER_REPOSITORY=dixneuf19
IMAGE_NAME=kube-webhook-arm-checker
IMAGE_TAG=$(shell git rev-parse --short HEAD)
DOCKER_IMAGE_PATH=$(DOCKER_REPOSITERY)/$(IMAGE_NAME):$(IMAGE_TAG)
PLATFORMS=linux/amd64,linux/arm64,linux/386,linux/arm/v7
KUBE_NAMESPACE=webhook

all: help

## help: Display list of commands
help: Makefile
	@sed -n 's|^##||p' $< | column -t -s ':' | sed -e 's|^| |'

## test: Run tests
test: fmt vet
	go test ./... -coverprofile cover.out

## build: Build manager binary
build: fmt vet
	go build -o bin/webhook main.go

## run: Run locally
run: fmt vet
	go run ./main.go

## fmt: Run go fmt against code
fmt:
	go fmt ./...

## vet: Run go vet against code
vet:
	go vet ./...

## docker-build: Build the docker image
docker-build: test
	docker build -t $(DOCKER_IMAGE_PATH) .

## docker-build: Build the docker image for multiple platforms
docker-build-multi: test
	@echo "Building docker for platforms $(PLATFORMS)..."
	docker buildx build --platform $(PLATFORMS) -t $(DOCKER_IMAGE_PATH) .

## docker-push: Push the docker image
docker-push:
	docker push ${IMG}
