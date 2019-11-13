andrewrothstein.argocd
=========
[![Build Status](https://travis-ci.org/andrewrothstein/ansible-argocd.svg?branch=master)](https://travis-ci.org/andrewrothstein/ansible-argocd)

Installs [argocd](https://argoproj.github.io/argo-cd/).

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - andrewrothstein.argocd
```

License
-------

MIT

Author Information
------------------

Andrew Rothstein <andrew.rothstein@gmail.com>
