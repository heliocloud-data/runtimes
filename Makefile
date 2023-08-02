# Makefile for convenience, (doesn't look for command outputs)
 
# just a scratch directory for testing
TESTDIR=/tmp/test-container

.PHONY: all
all: helio-notebook helio-notebook-mktrch

.PHONY: helio-notebook
helio-notebook : helio-notebook-build helio-notebook-test

.PHONY: helio-notebook-build
helio-notebook-build:
	cd helio-notebook/docker-image; \
	# this step takes a LONG time
	# conda-lock lock --mamba -k explicit -f ../../helio-notebook-base/conda/environment.yml -f environment.yml -p linux-64; \
	docker build -t heliocloud/helio-notebook:dev .; 

.PHONY: helio-notebook-test
helio-notebook-test :
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook:dev helio-notebook/docker-image/run_tests.sh helio-notebook

.PHONY: helio-notebook-mltrch
helio-ml-notebook-mltrch : 
	cd helio-notebook-mltrch/docker-image; \
	# this step takes a LONG time
	# conda-lock lock --mamba -k explicit -f ../../helio-notebook-base/conda/environment.yml -f ../../helio-notebook/conda/environment.yml -f environment.yml -p linux-64; \
	docker build -t heliocloud/helio-notebook-mltrch:dev . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook-mltrch:dev ../../helio-notebook/docker-image/run_tests.sh helio-notebook-mltrch \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) panhelio/helio-notebook-mltrch:dev ./run_tests.sh helio-notebook-mltrch


