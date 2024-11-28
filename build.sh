#!/bin/sh
docker build -t scenario-runner -f Dockerfile . "$@"
