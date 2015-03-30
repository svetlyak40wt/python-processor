Changelog
=========

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
