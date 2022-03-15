# -*- coding: utf-8 -*-


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
