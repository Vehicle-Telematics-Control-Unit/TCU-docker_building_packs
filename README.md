# Building packages docker image

This repo contains docker file for necessary building packages used by services on the TCU
it's considered as the parent docker image.

## How to use it
add this as the builder image in your docker files
```dockerfile

FROM registry.digitalocean.com/vehicle-plus/tcu_builder_packs:v8 as builder

COPY build_src build_src


# install those as they are not included in the building image
RUN apk update && apk add --no-cache --virtual .second_build_dependency \
    binutils cmake curl gcc g++ git libtool make tar build-base linux-headers

## ............

FROM alpine:3.17.2

## ......

```

## how to run
if you want to rebuild the docker image run this script
```bash
$ sudo ./multiarch_build.sh
```