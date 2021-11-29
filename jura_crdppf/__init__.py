from pyramid.config import Configurator
import c2cwsgiutils.pyramid
import os
import yaml


def main(_, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    route_prefix = os.environ.get('OEREB_ROUTE_PREFIX', 'oereb')

    config = Configurator(settings=settings)

    # Read and update settings for oereb client
    settings = config.get_settings()
    with open(settings.get('oereb_client.cfg'), encoding='utf-8') as f:
        settings.update({
            'oereb_client': yaml.load(f.read()).get('oereb_client')
        })

    # Include pyramid_oereb back-end configuration
    config.include('pyramid_oereb', route_prefix=route_prefix)

    # Including oereb_client configuration
    config.include('oereb_client', route_prefix=route_prefix)

    # Including custom views configuration
    config.include('jura_crdppf.views', route_prefix=route_prefix)

    config.scan()
    return config.make_wsgi_app()
