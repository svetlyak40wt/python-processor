Changelog
=========

0.6.0 (2015-05-01)
------------------

The biggest change in this release is a new source – ``github.releases``.
It is able to read all new releases in given repository and send them into
processing pipeline. This works as for public repositories, and for private
too. `Read the docs`_ for futher details.

.. _Read the docs: /sources.html#github-releases

Other changes are:

* Storage backend now saves JSON database nicely pretty printed for you could read and edit it in your favorite editor. This is Emacs, right?
* Twitter.search source now saves state after the tweet was processed. This way processor shouldn't loose tweets if there was exception somewhere in processing pipeline.
* IMAP source was fixed and now is able to fetch emails from really big folders.


0.5.0 (2015-04-15)
------------------

Good news, everyone! New output was added - ``email``.
Now Processor is able to notify you via email about any event.

0.4.0 (2015-04-06)
------------------

* Function ``run_pipline`` was simplified and now accepts only one source and one ouput.
  To implement more complex pipelines, use ``sources.mix`` and ``outputs.fanout`` helpers.

0.3.0 (2015-04-01)
------------------

* Added a `web.hook`_ source.
* Now `source` could be not only a iterable object, but any function which returns values.

.. _web.hook: /sources.html#web-hook

0.2.1 (2015-03-30)
------------------

Fixed error in ``import-or-error`` macro, which prevented from using 3-party libraries.

0.2.0 (2015-03-30)
------------------

Most 3-party libraries are optional now. If you want to use
some extension which requires external library, it will issue
an error and call ``sys.exit(1)`` until you satisfy this
requirement.

This should make life easier for thouse, who does not want
to use ``rss`` output which requires ``feedgen`` which requires
``lxml`` which is hard to build because it is C extension.

0.1.0 (2015-03-18)
------------------

* First release on PyPI.
