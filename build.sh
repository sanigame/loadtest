#!/bin/bash

JMETER_VERSION="5.1.1"

# Example build line
# --build-arg IMAGE_TIMEZONE="Asia/Bangkok"
docker build  --build-arg JMETER_VERSION=${JMETER_VERSION} -t "ktb-next-loadtest/jmeter:${JMETER_VERSION}" .
