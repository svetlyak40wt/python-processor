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
