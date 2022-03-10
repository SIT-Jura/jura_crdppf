from pyramid.config import Configurator
import os
from pyaml_env import parse_config

def main(_, **settings):
    """ This function returns a Pyramid WSGI application.
    """

    yml = parse_config('config/oereb_client.yml')
    settings.update(yml)
    config = Configurator(settings=settings)

    route_prefix = os.environ.get('OEREB_CLIENT_ROUTE_PREFIX', 'oereb')

    # Including oereb_client configuration
    config.include('oereb_client', route_prefix=route_prefix)

    # Including custom views configuration
    config.include('jura_crdppf_client.views', route_prefix=route_prefix)

    config.scan()
    return config.make_wsgi_app()


def includeme(config):
    config.include('oereb_client')
