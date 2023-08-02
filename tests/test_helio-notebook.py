import pytest
import importlib
import sys
import os

packages = [
    # these are problem libraries that don't always seem to import, mostly due
    # to dependencies outside the python world
    'netCDF4', 'h5py', 'pysat', #'pysatSeasons', 'pysatNASA', 'pysatMissions',
    # key packages
    's3fs', 'xarray' #, 'intake'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)
    
def test_start():
    print(os.environ)
    if os.environ.get('PANHELIO_ENV') is not None:
        assert os.environ['PANHELIO_ENV'] == 'helio-notebook-py'
