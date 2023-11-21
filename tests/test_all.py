import pytest
import importlib
import os.path
import sys

def test_config_paths():
    assert os.path.exists('/etc/profile.d/init_conda.sh')
    assert os.path.exists('/srv/conda/.condarc')
    assert os.path.exists('/srv/start')
    assert os.path.exists('/etc/profile.d/show_motd.sh')


def test_environment_variables():
    # These are required for jupyterhub and binderhub compatibility
    assert os.environ['NB_USER'] == 'jovyan'
    assert os.environ['NB_UID'] == '1000'
    assert 'NB_PYTHON_PREFIX' in os.environ


def test_default_conda_environment():
    assert sys.prefix == '/srv/conda/envs/notebook'

packages = [
    # included in panhelio-notebook metapackage
    # https://github.com/conda-forge/panhelio-notebook-feedstock/blob/master/recipe/meta.yaml
    'dask', 'distributed', 'dask_gateway', 'dask_labextension', 
    # key HelioCloud packages
    'cloudcatalog',
    # jupyterhub and related utilities
    'jupyterhub', 'jupyterlab', 'nbgitpuller',
    # aws/storage stuff
    's3fs', 'kerchunk', 'h5py', 'xarray', #, 'intake'
    # pyhc core 
    'hapiplot',
    'kamodo',
    'netCDF4',
    'plasmapy',
    'spacepy', 'sunpy',
    #'pysat', #'pysatSeasons', 'pysatNASA', 'pysatMissions',
    # key packages
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)

def test_dask_config():
    import dask
    assert '/srv/conda/etc' in dask.config.paths
    assert dask.config.config['labextension']['factory']['class'] == 'LocalCluster'

# Works locally but hanging on GitHub Actions, possibly due to:
# Unclosed client session client_session: <aiohttp.client.ClientSession object at 0x7ff7a2931950>
#@pytest.fixture(scope='module')
#def client():
#    from dask.distributed import Client
#    with Client(n_workers=4) as dask_client:
#        yield dask_client
#
#def test_check_dask_version(client):
#    print(client)
#    versions = client.get_versions(check=True)
