#! /bin/bash

build_version=v8

docker login registry.digitalocean.com/vehicle-plus

docker buildx build --push \
--platform linux/amd64,linux/arm64 \
--tag registry.digitalocean.com/vehicle-plus/tcu_builder_packs:${build_version} .