================
python-processor
================

Badges
======

| |docs| |travis| |appveyor| |coveralls| |landscape| |scrutinizer|
| |version| |downloads| |wheel| |supported-versions| |supported-implementations|

.. |docs| image:: https://readthedocs.org/projects/python-processor/badge/?style=flat
    :target: https://readthedocs.org/projects/python-processor
    :alt: Documentation Status

.. image:: http://allmychanges.com/p/python/processor/badge/
   :target: http://allmychanges.com/p/python/processor/?utm_source=badge

.. |travis| image:: http://img.shields.io/travis/svetlyak40wt/python-processor/master.png?style=flat
    :alt: Travis-CI Build Status
    :target: https://travis-ci.org/svetlyak40wt/python-processor

.. |appveyor| image:: https://ci.appveyor.com/api/projects/status/github/svetlyak40wt/python-processor?branch=master
    :alt: AppVeyor Build Status
    :target: https://ci.appveyor.com/project/svetlyak40wt/python-processor

.. |coveralls| image:: http://img.shields.io/coveralls/svetlyak40wt/python-processor/master.png?style=flat
    :alt: Coverage Status
    :target: https://coveralls.io/r/svetlyak40wt/python-processor

.. |landscape| image:: https://landscape.io/github/svetlyak40wt/python-processor/master/landscape.svg?style=flat
    :target: https://landscape.io/github/svetlyak40wt/python-processor/master
    :alt: Code Quality Status

.. |version| image:: http://img.shields.io/pypi/v/processor.png?style=flat
    :alt: PyPI Package latest release
    :target: https://pypi.python.org/pypi/processor

.. |downloads| image:: http://img.shields.io/pypi/dm/processor.png?style=flat
    :alt: PyPI Package monthly downloads
    :target: https://pypi.python.org/pypi/processor

.. |wheel| image:: https://pypip.in/wheel/processor/badge.png?style=flat
    :alt: PyPI Wheel
    :target: https://pypi.python.org/pypi/processor

.. |supported-versions| image:: https://pypip.in/py_versions/processor/badge.png?style=flat
    :alt: Supported versions
    :target: https://pypi.python.org/pypi/processor

.. |supported-implementations| image:: https://pypip.in/implementation/processor/badge.png?style=flat
    :alt: Supported imlementations
    :target: https://pypi.python.org/pypi/processor

.. |scrutinizer| image:: https://img.shields.io/scrutinizer/g/svetlyak40wt/python-processor/master.png?style=flat
    :alt: Scrtinizer Status
    :target: https://scrutinizer-ci.com/g/svetlyak40wt/python-processor/


Installation
============

Create viritualenv with python3:::
  
   virtualenv --python=python3 env
   source env/bin/activate

If you are on OSX, then install lxml on OSX separately:::
   
   STATIC_DEPS=true pip install lxml


Then install the ``processor``:::

    pip install processor

Now create an executable python script, where you'll place your pipline's configuration.
Usually it is looks like that:

.. code:: python

    #!env/bin/python3
    import os
    from processor import run_pipeline, sources, outputs
    from twiggy_goodies.setup import setup_logging


    for_any_message = lambda msg: True

    def prepare(tweet):
        return {'text': tweet['text'],
                'from': tweet['user']['screen_name']}

    setup_logging('twitter.log')

    run_pipeline(
        sources=[sources.twitter.search(
            'My Company',
            consumer_key='***', consumer_secret='***',
            access_token='***', access_secret='***',
            )],
        rules=[(for_any_message, [prepare, outputs.debug()])])


Running this code, will fetch new results for search by query ``My Company``
and output them on the screen. Of course, you could use any other ``output``,
supported by the ``processor``. Browse online documentation to find out
which sources and outputs are supported and for to configure them.
    

Documentation
=============

https://python-processor.readthedocs.org/


Development
===========

To run the all tests run::

    tox


Twitter source
==============

* Go to https://apps.twitter.com
* Create new app.
* Go to "Keys and Access Tokens" tabs.
* Copy "Consumer Key", "Consumer Secret".
* Create "Access Token" and "Access Secret" and copy them too.
