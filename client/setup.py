from setuptools import setup, find_packages

requires = [
    'oereb-client==2.1.1'
]

setup(name='jura_crdppf_client',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    install_requires=requires,
      entry_points={
          'paste.app_factory': [
              'main = jura_crdppf_client:main'
          ],
      }
)
