from pyramid.config import Configurator
import os
import yaml


def main(_, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    route_prefix = os.environ.get('OEREB_SERVER_ROUTE_PREFIX', 'oereb')

    config = Configurator(settings=settings)

    # Include pyramid_oereb back-end configuration
    config.include('pyramid_oereb', route_prefix=route_prefix)

    config.scan()
    return config.make_wsgi_app()
