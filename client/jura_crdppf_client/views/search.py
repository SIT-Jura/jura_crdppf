# -*- coding: utf-8 -*-
import pkg_resources

from concurrent.futures import as_completed
from defusedxml.ElementTree import fromstring
from mako.template import Template
from requests_futures.sessions import FuturesSession


def hook_egrid(config, response, lang, default_lang):
    if len(response.get('features')) < 1:
        return None

    results = []

    for result in response.get('features'):
        egrid = result.get('properties').get('label')[8:]
        results.append({
            'label': egrid,
            'egrid': egrid
        })

    return results


def hook_address(config, response, lang, default_lang):
    if len(response.get('features')) < 1:
        return None

    results = []

    for result in response.get('features'):
        results.append({
            'label': result.get('properties').get('label')[0:-10],
            'coordinates': result.get('geometry').get('coordinates')
        })

    return results


def hook_real_estate(config, response, lang, default_lang):
    features = response.get('features')
    if len(features) < 1:
        return None

    wfs_filter = Template(filename=pkg_resources.resource_filename('jura_crdppf_client.views', 'wfs_filter.xml'))

    requests = []
    headers = {'Content-Type': 'application/xml'}
    session = FuturesSession(max_workers=len(features))
    for result in features:
        elements = result.get('properties').get('label')[0:-20].split(' ')
        filter = wfs_filter.render(
            layer_name='grundstueck',
            parcel_number=elements.pop(),
            municipality_name=' '.join(elements).replace(' (JU)', ''),
            limit=1
        ).encode('utf-8')
        requests.append(session.post('https://geo.jura.ch', data=filter, headers=headers))

    results = []

