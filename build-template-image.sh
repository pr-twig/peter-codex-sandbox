#!/bin/sh
docker build -t elia-dev-sandbox-kit .
docker image save elia-dev-sandbox-kit -o template-image.tar
sbx template load template-image.tar
rm template-image.tar || true
