import pytest
import importlib
import sys
import os

packages = [
    # key packages
    'tensorflow', 
    'keras',
    'keras_cv',
    'jax'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)
    
def test_start():
    print(os.environ)
    if os.environ.get('HELIOCLOUD_ENV') is not None:
        assert os.environ['HELIOCLOUD_ENV'] == 'helio-notebook-mltf'
