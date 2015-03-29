Simple rules
==============

Python processor is a tool for creating chained pipelines for dataprocessing.
It have very few key concepts:

Data object
    Any python dict with two required fields: ``source`` and ``type``.
Source
    Any function which returns iterable sequence of ``data objects``.
Output
    A function which accepts a ``data object`` as input and could output another
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

Create viritualenv with python3:::
  
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
