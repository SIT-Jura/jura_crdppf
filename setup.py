from setuptools import setup, find_packages

requires = [
    # 'oereb-client==1.3.8',
    'pyramid_oereb[recommend]==2.0.0.b3'
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
