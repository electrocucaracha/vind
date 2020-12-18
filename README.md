# vind (Vagrant-in-Docker)

[![Docker](https://images.microbadger.com/badges/image/electrocucaracha/vind.svg)](http://microbadger.com/images/electrocucaracha/vind)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

### Usage

Use this ```Dockerfile``` to build a base image for your integration
tests in [Concourse CI](http://concourse.ci/).

Here is an example of a Concourse
[job](https://concourse-ci.org/jobs.html) that uses
```electrocucaracha/vind``` image to run a bunch of containers in a
task, and then runs the integration test suite.


```yaml
  - name: integration
    plan:
      - get: code
        params: {depth: 1}
        passed: [unit-tests]
        trigger: true
      - task: Run integration tests
        privileged: true
        config:
          platform: linux
          image_resource:
            type: docker-image
            source:
              repository: electrocucaracha/vind
          inputs:
            - name: code
          run:
            dir: src
            path: bash
            args:
              - -exc
              - |
                source /libvirtd-lib.sh
                start_libvirtd

                vagrant up
```
