=======
Sources
=======

.. _full list of sources:

IMAP
====

Imap source is able to read new emails from specified folder on IMAP server.
All you need is to specify server's address, optional port and user credentials:

Example::

  from processor import run_pipeline, source, outputs
  run_pipeline(
      sources=[sources.imap("imap.gmail.com",
                            "username",
                            "****word",
                            "Inbox")],
      rules=[(for_any_message, [outputs.debug()])])

This script will read ``Inbox`` folder at server ``imap.gmail.com``
and print resulting dicts to the terminal's screen.

Twitter
=======

.. Note::
   To use this source, you need to obtain an access token from twitter.
   There is a detailed instruction how to do this `Twitter's documentation`_.
   You could encapsulate twitter credentials into a dict2:

   .. code:: python

      twitter_creds = dict(consumer_key='***', consumer_secret='***',
                           access_token='***', access_secret='***')
      sources.twitter.search('Some query', **twitter_creds)
      sources.twitter.followers(**twitter_creds)


.. _Twitter's documentation: https://dev.twitter.com/oauth/overview/application-owner-access-tokens

twitter.search
--------------

This source runs search by given query in Twitter and returns fresh
results::

  from processor import run_pipeline, source, outputs
  run_pipeline(
      sources=[sources.twitter.search(
                  'iOS release notes', **twitter_creds)],
      rules=[(for_any_message, [outputs.debug()])])

It returns following fields:

source
    twitter.search
type
    twitter.tweet
*other*
    Other fields are same as them returns Twitter API. See section "Example Result" at twitter's docs on `search/tweets`_.

.. _search/tweets: https://dev.twitter.com/rest/reference/get/search/tweets


twitter.followers
-----------------

First invocation returns all who you follows, each next -- only new followers::

  from processor import run_pipeline, source, outputs
  run_pipeline(
      sources=[sources.twitter.followers(**twitter_creds)],
      rules=[(for_any_message, [outputs.debug()])])


It returns following fields:

source
    twitter.followers
type
    twitter.user
*other*
    Other fields are same as them returns Twitter API. See section "Example Result" at twitter's docs on `followers/list`_.

.. _followers/list: https://dev.twitter.com/rest/reference/get/followers/list

boo

