# Makefile for convenience, (doesn't look for command outputs)
 
# just a scratch directory for testing
TESTDIR=/tmp/test-container

.PHONY: all
all: helio-notebook helio-notebook-mktrch

.PHONY: helio-notebook
helio-notebook : helio-notebook-build helio-notebook-test

.PHONY: helio-notebook-conda
helio-notebook-conda :
	# WARNING this takes a while 
	conda-lock lock --mamba -k explicit -f helio-notebook-base/conda/environment.yml -f helio-notebook/conda/environment.yml -p linux-64; \
	mv conda-linux-64.lock helio-notebook/docker-image;

.PHONY: helio-notebook-build
helio-notebook-build:
	cd helio-notebook/docker-image; \
	docker build -t heliocloud/helio-notebook:dev .; 

.PHONY: helio-notebook-test
helio-notebook-test :
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook:dev helio-notebook/docker-image/run_tests.sh helio-notebook

.PHONY: helio-notebook-mltrch
helio-notebook-mltrch : helio-notebook-mltrch-build helio-notebook-mltrch-test
	 
.PHONY: helio-notebook-mltrch-conda
helio-notebook-mltrch-conda:
	# WARNING this takes a while 
	conda-lock lock --mamba -k explicit -f helio-notebook-base/conda/environment.yml -f helio-notebook/conda/environment.yml -f helio-notebook-mltrch/conda/environment.yml -p linux-64; \
	mv conda-linux-64.lock helio-notebook-mltrch/docker-image;
	
.PHONY: helio-notebook-mltrch-build
helio-notebook-mltrch-build:
	cd helio-notebook-mltrch/docker-image; \
	docker build -t heliocloud/helio-notebook-mltrch:dev .;

.PHONY: helio-notebook-mltrch-test
helio-notebook-mltrch-test: 
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook-mltrch:dev helio-notebook/docker-image/run_tests.sh helio-notebook; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook-mltrch:dev helio-notebook-mltrch/docker-image/run_tests.sh helio-notebook-mltrch


