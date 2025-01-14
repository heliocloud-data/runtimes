# Makefile for convenience, (doesn't look for command outputs)
 
# just a scratch directory for testing
TESTDIR=/tmp/test-container

.PHONY: all
all: helio-daskhub-core helio-daskhub-mltf helio-daskhub-mktrch

.PHONY: helio-daskhub-core
helio-daskhub-core : helio-daskhub-core-build helio-daskhub-core-test

.PHONY: helio-daskhub-core-conda
helio-daskhub-core-conda :
	# WARNING this takes a while 
	conda-lock lock --mamba -k explicit -f helio-base/conda/environment.yml -f helio-daskhub-core/conda/environment.yml -p linux-64; \
	mv conda-linux-64.lock helio-daskhub-core/docker-image;

.PHONY: helio-daskhub-core-build
helio-daskhub-core-build:
	cd helio-daskhub-core/docker-image; \
	docker build -t heliocloud/helio-daskhub-core:dev .; 

.PHONY: helio-daskhub-core-test
helio-daskhub-core-test :
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-daskhub-core:dev helio-daskhub-core/docker-image/run_tests.sh helio-notebook

.PHONY: helio-daskhub-mltf
helio-daskhub-mltf : helio-daskhub-mltf-build helio-daskhub-mltf-test

.PHONY: helio-daskhub-mltf-conda
helio-daskhub-mltf-conda:
	# WARNING this takes a while
	conda-lock lock --mamba -k explicit -f helio-base/conda/environment.yml -f helio-daskhub-core/conda/environment.yml -f helio-daskhub-mltf/conda/environment.yml -p linux-64; \
	mv conda-linux-64.lock helio-daskhub-mltf/docker-image;

.PHONY: helio-daskhub-mltf-build
helio-daskhub-mltf-build:
	cd helio-daskhub-mltf/docker-image; \
	docker build -t heliocloud/helio-daskhub-mltf:dev .;

.PHONY: helio-daskhub-mltf-test
helio-daskhub-mltf-test:
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-daskhub-mltf:dev helio-daskhub-core/docker-image/run_tests.sh helio-notebook-mltf; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-daskhub-mltf:dev helio-daskhub-mltf/docker-image/run_tests.sh helio-notebook-mltf

.PHONY: helio-daskhub-mltrch
helio-daskhub-mltrch : helio-daskhub-mltrch-build helio-daskhub-mltrch-test
	 
.PHONY: helio-daskhub-mltrch-conda
helio-daskhub-mltrch-conda:
	# WARNING this takes a while 
	conda-lock lock --mamba -k explicit -f helio-base/conda/environment.yml -f helio-daskhub-core/conda/environment.yml -f helio-daskhub-mltrch/conda/environment.yml -p linux-64; \
	mv conda-linux-64.lock helio-daskhub-mltrch/docker-image;
	
.PHONY: helio-daskhub-mltrch-build
helio-daskhub-mltrch-build:
	cd helio-daskhub-mltrch/docker-image; \
	docker build -t heliocloud/helio-daskhub-mltrch:dev .;

.PHONY: helio-daskhub-mltrch-test
helio-daskhub-mltrch-test: 
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-daskhub-mltrch:dev helio-daskhub-core/docker-image/run_tests.sh helio-notebook-mltrch; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) heliocloud/helio-daskhub-mltrch:dev helio-daskhub-mltrch/docker-image/run_tests.sh helio-notebook-mltrch
