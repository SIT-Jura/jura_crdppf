from setuptools import setup, find_packages

requires = [
    'pyramid_oereb[recommend]==2.0.0.b6',
    'oereb-client==2.0.0.dev202112060937'
]

setup(
    name='jura_crdppf',
    version='0.0.0',
    description='jura_crdppf',
    long_description="jura_crdppf",
    classifiers=[
      "Programming Language :: Python",
      "Framework :: Pyramid",
      "Topic :: Internet :: WWW/HTTP",
      "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
      ],
    author='Camptocamp',
    author_email='info@camptocamp.org',
    url='',
    keywords='web pyramid pylons',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    install_requires=requires,
    tests_require=requires,
    entry_points={
        "paste.app_factory": [
            "main = jura_crdppf:main"
        ],
    },
)
