# Makefile for convenience, (doesn't look for command outputs)
 
# just a scratch directory for testing
TESTDIR=/tmp/test-container

.PHONY: all
all: helio-notebook helio-notebook-mltf helio-notebook-mktrch

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

.PHONY: helio-notebook-mltf
helio-notebook-mltf : helio-notebook-mltf-build helio-notebook-mltf-test

.PHONY: helio-notebook-mltf-conda
helio-notebook-mltf-conda:
	# WARNING this takes a while
	conda-lock lock --mamba -k explicit -f helio-notebook-base/conda/environment.yml -f helio-notebook/conda/environment.yml -f helio-notebook-mltf/conda/environment.yml -p linux-64; \
	mv conda-linux-64.lock helio-notebook-mltf/docker-image;

.PHONY: helio-notebook-mltf-build
helio-notebook-mltf-build:
	cd helio-notebook-mltf/docker-image; \
	docker build -t heliocloud/helio-notebook-mltf:dev .;

.PHONY: helio-notebook-mltf-test
helio-notebook-mltf-test:
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook-mltf:dev helio-notebook/docker-image/run_tests.sh helio-notebook-mltf; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook-mltf:dev helio-notebook-mltf/docker-image/run_tests.sh helio-notebook-mltf

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
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook-mltrch:dev helio-notebook/docker-image/run_tests.sh helio-notebook-mltrch; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-notebook-mltrch:dev helio-notebook-mltrch/docker-image/run_tests.sh helio-notebook-mltrch


