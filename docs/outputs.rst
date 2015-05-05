=======
Outputs
=======

debug
=====

This output is very useful for debugging you input. All it does right
now -- returns ``pprint`` function, but possible interface will be extended
in future to select which fields to ouput or suppress, cache or something like
that.

fanout
======

Fanout output is useful, when you want to feed one data objects stream to two
or more pipelines. For example, you could send some events by email and into
the `slack`_ chat simultaneously::

  run_pipeline(some_source(),
               outputs.fanout(
                  outputs.email('vaily@pupkin.name'),
                  outputs.slack(SLACK_URL)))

Or if you need to preprocess data objects for each output, then code will
looks like this::

  run_pipeline(some_source(),
               outputs.fanout(
                  [prepare_email, outputs.email('vaily@pupkin.name')],
                  [prepare_slack, outputs.slack(SLACK_URL)]))

Where ``prepare_email`` and ``prepare_slack`` just a functions which return
data objects with fields for `email` and `slack`_ outputs.


email
=====

Sends an email to given address via configured SMTP server.
When configuring, you have to specify ``host``, ``port``, ``user`` and ``password``.
And also a ``mail_to``, which is an email of recipient who should receive a message
and ``mail_from`` which should be a tuple like ``(name, email)`` and designate
sender. Here is an example::

  run_pipeline(
    [{'subject': 'Hello from processor',
      'body': 'The <b>HTML</b> body.'}],
    outputs.email(mail_to='somebody@gmail.com',
                  mail_from=('Processor', 'processor@yandex.ru'),
                  host='smtp.yandex.ru',
                  user='processor',
                  password='***',
                  port=465,
                  ssl=True,
              ))


Each data object should contain these fields:

**subject**
    Email's subject
**body**
    HTML body of the email.


rss
===

Creates an RSS feed on the disk. Has one required parameter --
``filename`` and one optional -- ``limit``, which is ``10`` by default and
limiting result feed's length.

Each data object should contain these fields:

**title**
    Feed item's title.
**id** (optional)
    Feed item's unique identifier. If not provided, then md5 hash from title will be used.
**body**
    Any text to be placed inside of rss item's body.


slack
=====

Write a message to Slack chat. A message could be sent to a
channel or directly to somebody.

This output has one required parameter ``url``. You could
obtain it at the Slack's integrations page. Select "Incoming WebHooks"
among all available integrations. Add a hook and copy it's ``url``
into the script. Other parameter is ``defaults``. It is a dict to be merged with each data object and by default it has ``{"renderer": "markdown", "username": "Processor"}`` value.

Each data object should contain these fields:

**text**
    Text of the message to be posted. This is only required field. Other fields are optional and described on Slack's integration page.
**username** (optional)
    A name to be displayed as sender's name.
**icon_url** (optional)
    A link to png icon. It should be 57x57 pixels.
**icon_emoji** (optional)
    An emoji string. Choose one at `Emoji Cheat Sheet`_.
**channel**
    A public channel can be specified with ``#other-channel``, and a Direct Message with ``@username``.

    
XMPP
=====

XMPP output sends messages to given jabber id (JID). It connects
as a Jabber client to a server and sends messages through it.

.. Note::
   If you use Google's xmpp, then you will need to add Bot's JID into
   your roster. Otherwise, messages will not be accepted by server.
   
This output is configured by three parameters ``jid``, ``password`` and ``host``.
They are used to connect to a server as a jabber client. Optionally,
you could specify ``port`` (which is 5222 by default) and ``recipients`` –
a list of who need to be notified. Recipients list could be overriden
if data object contains field ``recipients``.

Each data object should contain these fields:

**text**
    Text of the message to be posted.
**recipients** (optional)
    A list of JIDs to be notified.

