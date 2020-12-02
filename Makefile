DOCKER_BUILDKIT ?= 1
export DOCKER_BUILDKIT

REPO ?= docker.io/ornew
BASE_IMAGE ?= docker.io/ubuntu:focal-20201008

$(shell mkdir -p images)

images/runtime:

images/builder: builder/Dockerfile
	docker build \
		--progress plain \
		--build-arg base_image=$(BASE_IMAGE) \
		--tag $(REPO)/builder \
		builder

images/openjdk: openjdk/Dockerfile
	docker build \
		--progress plain \
		--build-arg builder_image=${REPO}/builder \
		--build-arg base_image=$(BASE_IMAGE) \
		--tag $(REPO)/openjdk \
		openjdk

images/spark: spark/Dockerfile
	docker build \
		--progress plain \
		--build-arg builder_image=${REPO}/builder \
		--build-arg base_image=${BASE_IMAGE} \
		--tag $(REPO)/spark \
		spark

images/pyspark: pyspark/Dockerfile
	docker build \
		--progress plain \
		--build-arg base_image=${REPO}/spark \
		--tag $(REPO)/pyspark \
		pyspark

images/jupyter: jupyter/Dockerfile
	docker build \
		--progress plain \
		--build-arg builder_image=${REPO}/builder \
		--tag $(REPO)/jupyter \
		jupyter
