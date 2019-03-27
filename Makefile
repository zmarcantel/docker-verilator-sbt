AUTHOR=zmar
PROJ=sbt-verilator
DOCKERIMAGE=$(AUTHOR)/$(PROJ)

SBT_VERSION=1.2.8
VERILATOR_VERSION=4.012

default: image

image:
	docker build \
		--tag $(DOCKERIMAGE) \
		--build-arg "SBT_VERSION=$(SBT_VERSION)" \
		--build-arg "VERILATOR_VERSION=$(VERILATOR_VERSION)" \
		.

push: image
	docker push $(DOCKERIMAGE)

bash: image
	docker run --rm -ti $(DOCKERIMAGE) bash
