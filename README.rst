================
python-processor
================

Badges
======

| |docs| |changelog| |travis| |coveralls| |landscape| |scrutinizer|
| |version| |downloads| |wheel| |supported-versions| |supported-implementations|

.. |docs| image:: https://readthedocs.org/projects/python-processor/badge/?style=flat
    :target: https://readthedocs.org/projects/python-processor
    :alt: Documentation Status

.. |changelog| image:: http://allmychanges.com/p/python/processor/badge/
    :target: http://allmychanges.com/p/python/processor/?utm_source=badge
    :alt: Release Notes

.. |travis| image:: http://img.shields.io/travis/svetlyak40wt/python-processor/master.png?style=flat
    :alt: Travis-CI Build Status
    :target: https://travis-ci.org/svetlyak40wt/python-processor

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


Simple rules
==============

Python processor is a tool for creating chained pipelines for dataprocessing.
It have very few key concepts:

Data object
    Any python dict with two required fields: ``source`` and ``type``.
Source
    An iterable sequence of ``data objects`` or a function which returns ``data objects``.
    See `full list of sources`_ in the docs.
Output
    A function which accepts a ``data object`` as input and could output another. See `full list of outputs`_ in the docs.
    (or same) ``data object`` as result.
Predicate
    Pipeline consists from sources outputs, but ``predicate`` decides which
    ``data object`` should be processed by which ``output``.

Quick example
=============

Here is example of pipeline which reads IMAP folder and sends all emails to Slack chat:

.. code:: python

    run_pipeline(
        sources=[sources.imap('imap.gmail.com'
                              'username',
                              'password'
                              'INBOX')],
        rules=[(for_any_message, [email_to_slack, outputs.slack(SLACK_URL)])])

Here you construct a pipeline, which uses ``sources.imap`` for reading imap folder
"INBOX" of ``username@gmail.com``. Function ``for_any_message`` is a predicate saying
something like that: ``lambda data_object: True``. In more complex case predicates
could be used for routing dataobjects to different processors.

Functions ``email_to_slack`` and ``outputs.slack(SLACK_URL)`` are processors. First one
is a simple function which accepts data object, returned by imap source and transforming
it to the data object which could be used by slack.output. We need that because slack
requires a different set of fields. Call to ``outputs.slack(SLACK_URL)`` returns a
function which gets an object and send it to the specified Slack's endpoint.

It is just example, for working snippets, continue reading this documention ;-)

.. Note:: By the way, did you know there is a Lisp dialect which runs on Python
          virtual machine? It's name is HyLang, and python processor is written in this
          language.

    
Installation
============

Create a virtual environment with python3:::
  
   virtualenv --python=python3 env
   source env/bin/activate

If you are on OSX, then install lxml on OSX separately:::
   
   STATIC_DEPS=true pip install lxml


Then install the ``processor``:::

    pip install processor


Usage
=====

Now create an executable python script, where you'll place your pipline's configuration.
For example, this simple code creates a process line which searches new results in Twitter
and outputs them to console. Of cause, you can output them not only to console, but also
post by email, to Slack chat or everywhere else if there is an output for it:

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


.. _full list of sources: sources.html
.. _full list of outputs: outputs.html


Ideas for Sources and Outputs
=============================

* ``web-hook`` endpoint `(in progress)`.
* ``tail`` source which reads file and outputs lines appeared in a file between invocations
  or is able to emulate ``tail -f`` behaviour. Python module
  `tailer <https://pypi.python.org/pypi/tailer/>`_ could be used here.
* ``grep`` output -- a filter to grep some fields using patterns. With ``tail`` and ``grep``
  you could build a pipeline which watch on a log and send errors by email or to the chat.
* ``xmpp`` output.
* ``irc`` output.
* ``rss/atom feed reader``.
* ``weather`` source which tracks tomorrow's weather forecast and outputs a message if it was
  changed significantly, for example from "sunny" to "rainy".
* ``github`` some integrations with github API?
* ``jira`` or other task tracker of your choice?
* `suggest your ideas!`


Documentation
=============

https://python-processor.readthedocs.org/


Development
===========

To run the all tests run::

    tox

.. include:: AUTHORS.rst
.. include:: CHANGELOG.rst

