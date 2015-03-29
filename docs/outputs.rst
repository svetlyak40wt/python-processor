=======
Outputs
=======

debug
=====

This output is very useful for debugging you input. All it does right
now -- returns ``pprint`` function, but possible interface will be extended
in future to select which fields to ouput or suppress, cache or something like
that.

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

This outputter has one required parameter ``url``. You could
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

.. _Emoji Cheat Sheet: http://www.emoji-cheat-sheet.com

