#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c)
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o pipefail
set -o errexit
set -o nounset

if ! command -v docker; then
    # NOTE: Shorten link -> https://github.com/electrocucaracha/pkg-mgr_scripts
    curl -fsSL http://bit.ly/install_pkg | PKG=docker bash
fi

docker run --rm --privileged --workdir /tmp/ --entrypoint bash \
    --mount "type=bind,source=$(pwd)/Vagrantfile,target=/tmp/Vagrantfile" \
    electrocucaracha/vind \
    -exec "source /libvirtd-lib.sh; start_libvirtd; cat /etc/os-release; vagrant up; vagrant ssh -- cat /etc/os-release"
