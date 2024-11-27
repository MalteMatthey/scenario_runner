#!/bin/sh
docker build -t scenario-runner-docker -f Dockerfile . "$@"
