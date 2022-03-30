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


# Credits to https://progr.interplanety.org/en/python-how-to-find-the-polygon-center-coordinates/
def centroid(vertexes):
     _x_list = [vertex [0] for vertex in vertexes]
     _y_list = [vertex [1] for vertex in vertexes]
     _len = len(vertexes)
     _x = sum(_x_list) / _len
     _y = sum(_y_list) / _len
     return(_x, _y)


def hook_real_estate(config, response, lang, default_lang):
    features = response.get('features')
    if len(features) < 1:
        return None

    results = []

    for result in response.get('features'):
        result_properties = result.get('properties')
        result_label = result_properties.get('label')
        log.info("hook_real_estate reading feature with layername {}, label {}".format(result_properties.get('layer_name'), result_label))
        parcel_geom = result.get('geometry').get('coordinates')
        # Assumption: parcel geometry is always a multipolygon. Calculate the center of the first polygon of the center,
        # this will be a point that is certainly in the parcel and can therefore be used for oereb getegrid call
        parcel_first_polygon = parcel_geom[0][0]
        parcel_first_center = centroid(parcel_first_polygon)
        results.append({
            'label': result_label,
            'coordinates': parcel_first_center
        })

    return results
