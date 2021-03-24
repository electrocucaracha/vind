# vind (Vagrant-in-Docker)

[![Docker](https://images.microbadger.com/badges/image/electrocucaracha/vind.svg)](http://microbadger.com/images/electrocucaracha/vind)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Usage

Use this ```Dockerfile``` to build a base image for your integration
tests in [Concourse CI](http://concourse.ci/) or [Tekton CI/CD](https://tekton.dev/)

Here is an example of a Concourse
[job](https://concourse-ci.org/jobs.html) that uses
`electrocucaracha/vind` image. This approach has some limitations and
require special configuration in the worker node, for more information
check this [link](https://github.com/concourse/concourse/issues/2784)

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

                sudo -E vagrant up
```

Here is an example of a Tekton
[pipeline](https://tekton.dev/docs/pipelines/pipelines/) that uses
`electrocucaracha/vind` image.

```yaml
  tasks:
    - name: vagrant-up
      image: electrocucaracha/vind
      script: |
        source /libvirtd-lib.sh
        start_libvirtd

        cd src
        sudo -E vagrant up
      securityContext:
        privileged: true
        capabilities:
          add:
            - NET_ADMIN
      resources:
        inputs:
          - name: repo
            resource: src
```
