# Tests

## Unit tests
Various unit tests may be run using the 'make' command. For helio-notebook, for example:
```bash
> make helio-notebook-test
```

## Test Plan

### Summary

3 images are part of this plan, ‘helio-notebook’ and ‘helio-notebook-mltrch’ and ‘heliocloud-notebook-mltf’. This plan describes testing which must be passed in order to achieve a public release.

### Test Plan

Unit testing for package Installed/Imports (of default installed conda env– notebook)

### Test for critical HelioCloud packages
This is taken care of by the unit tests mentioned above

### Manual tests

#### Libraries 

Create a container on your machine with the test runtime image using docker, e.g.

bash```
> docker run -it <imageid> /bin/bash
```

from the prompt, test for presence of critical software libraries including LibGL.so and CDFLib.so. 
For ML-based images test for CUDA and either tensorflow or pytorch as appropriate. 

#### Runtime Image size / Time of Deployment 
Confirm that Test for image size not too large, in all cases less than 13 GB (manual).

#### Deployment Test 
For this test deploy the test runtime to a HelioCloud (test) environment. Make sure you can log in and see the top level daskhub view (e.g. the launcher). Time trying to log into the test environment. Ideally it can come up in less than 5 minutes.

#### Terminal-based Tests
Log in to the test environment and then open a terminal. From the terminal test for the following executables:
Deploy the runtime to a HelioCloud instance and then open a terminal. From the terminal test for the following executables:
0. conda
1. aws (client)
2. gcc
3. gfortran
4. python (expected version)

For the machine learning images, we need to run the GPU test
1. nvidia-smi 

Other tests from the terminal:
1. Also check for .bash profile exists
2. Check the Message of the Day comes up.
3. conda has "notebook" as default env (“conda info -e” in terminal)

### Notebooks
Download and unpack the test notebooks tarball.

1.  Uptime test: kernel and session doesn't time out for 4 hours. Use the UptimeCheck.ipynb notebook.
2. Test Dask/S3/boto3 (using test notebook) (“S3_Dask_Demo.ipynb”). Besure to click on dask dashboard link to check that its doing something (it may take a while to spin up burst node, you can check on AWS Console)
