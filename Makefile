include .env
include ./Makefile.base.mk

# -- cosmetics --
help-colw = 7

# -- constants --
db-entry = cmd/main.go
db-build = build
db-binary = $(FN_BINARY)
db-archive = $(FN_ARCHIVE)
dr-fn = $(FN_NAME)
dr-fixtures = fixtures
dr-input = $(dr-fixtures)/input.json
dr-output = $(dr-fixtures)/output.json
dr-endpoint = $(AWS_ENDPOINT)
df-infra = infra
df-tf = $(df-infra)/.terraform

# -- tools --
tb-go = go
tt-go = go
tr-aws = . .env && aws
tf-dc = LOCALSTACK_DOCKER_NAME=$(FN_NAME) docker-compose
tf-terraform = . .env && terraform -chdir="$(df-infra)"

# -- init --
## [i]init dev env
init: i
.PHONY: init

i: .env
.PHONY: i

.env: .env.sample
	cp .env.sample .env

# -- build --
## [b]uild handler fn
build: b
.PHONY: build

b:
	GOOS=linux GOARCH=amd64 $(tb-go) build -o $(db-binary) $(db-entry)
.PHONY: b

## clean the build
b/clean:
	rm -rf $(db-build)
.PHONY: b/clean

## build and archive
b/arch: b
	zip $(db-archive) $(db-binary)
.PHONY: b/arch

# -- run --
## [r]un handler fn
run: r
.PHONY: run

r:
	$(tr-aws) lambda invoke \
	--function-name $(dr-fn) \
	--payload $$(base64 < $(dr-input)) \
	--endpoint-url=$(dr-endpoint) \
	--debug \
	fixtures/output.json
.PHONE: r

# -- test --
## run [t]ests
test: t
.PHONY: test

t:
	$(tt-go) test ./... -run "_U"
.PHONY: t

## runs unit & int tests
t/all:
	$(tt-go) test ./...
.PHONY: t/all

# -- infra --
## in[f]ra; aliases f/plan
infra: f
.PHONY: infra

f: f/plan
.PHONY: f

## start localstack
f/start:
	$(tf-dc) up
.PHONY: f/start

## stop localstack
f/stop:
	$(tf-dc) down
.PHONY: f/stop

## plan dev infra
f/plan: $(df-tf)
	$(tf-terraform) plan
.PHONY: f

## validate infra
f/valid:
	$(tf-terraform) validate
.PHONY: f/validate

## apply planned infra
f/apply:
	$(tf-terraform) apply -auto-approve
.PHONY: f/apply

## destroy infra
f/clean:
	$(tf-terraform) destroy
.PHONY: f/reset

# -- i/helpers
$(df-tf):
	$(tf-terraform) init
