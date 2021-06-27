go lambda template
---

a template for a lambda fn using go, terraform, and localstack

# setup

install these in whatever way makes sense for your system. on mac, i personally manage them using a [brewfile](https://github.com/miseapp/share/blob/main/Brewfile).

- [golang](https://golang.org/doc/install)
- [docker](https://docs.docker.com/engine/install/)
- [terraform](https://www.terraform.io/downloads.html)
- [localstack](https://localstack.cloud/docs/getting-started/installation/)
- [awscli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

then init the dev env

```sh
$ make init
```

this template uses `make` as a task runner. to view a list of available tasks

```sh
$ make
```

# running

to test locally, first start docker. then start the localstack server

```sh
$ make f/start # wait for localstack to boot
```

build and zip the lambda fn

```sh
$ make b/arch
```

prepare the infrastructure

```sh
$ make f/plan
$ make f/apply
```

and then call the function:

```sh
$ make run
```

you should find the output in `fixtures/output.json`.
