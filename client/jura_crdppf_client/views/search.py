# -*- coding: utf-8 -*-
import logging
import pkg_resources

from concurrent.futures import as_completed
from defusedxml.ElementTree import fromstring
from mako.template import Template
from requests_futures.sessions import FuturesSession

log = logging.getLogger(__name__)


def hook_egrid(config, response, lang, default_lang):
    if len(response.get('features')) < 1:
        return None

    results = []

    for result in response.get('features'):
        result_properties = result.get('properties')
        result_label = result_properties.get('label')
        log.info("hook_egrid checking feature with layername {}, label {}".format(result_properties.get('layer_name'), result_label))

        egrid = result_label[8:]
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
        result_properties = result.get('properties')
        result_label = result_properties.get('label')
        log.info("hook_address checking feature with layername {}, label {}".format(result_properties.get('layer_name'), result_label))
        results.append({
            'label': result_label[0:-10],
            'coordinates': result.get('geometry').get('coordinates')
        })

    return results


def hook_real_estate(config, response, lang, default_lang):
    features = response.get('features')
    if len(features) < 1:
        return None

    results = []

    for result in response.get('features'):
        result_properties = result.get('properties')
        result_label = result_properties.get('label')
        log.info("hook_real_estate checking feature with layername {}, label {}".format(result_properties.get('layer_name'), result_label))
        results.append({
            'label': result_label,
            'coordinates': result.get('geometry').get('coordinates')
        })

    return results
