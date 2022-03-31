# -*- coding: utf-8 -*-
import logging


log = logging.getLogger(__name__)


def hook_egrid(config, response, lang, default_lang):
    if len(response.get('features')) < 1:
        return None

    results = []

    for result in response.get('features'):
        result_properties = result.get('properties')
        result_label = result_properties.get('label')
        log.info("hook_egrid reading feature with layername {}, label {}".format(result_properties.get('layer_name'), result_label))

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
        log.info("hook_address reading feature with layername {}, label {}".format(result_properties.get('layer_name'), result_label))
        results.append({
            'label': result_label[0:],
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
        egrid_in_label = result_label[-15:-1]
        log.info("hook_real_estate reading feature with layername {}, label {}, egrid_in_label {}".format(result_properties.get('layer_name'), result_label, egrid_in_label))
        results.append({
            'label': result_label,
            'egrid': egrid_in_label
        })

    return results
