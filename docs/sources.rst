=======
Sources
=======

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
