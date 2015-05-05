# -*- encoding: utf-8 -*-
import io
import re
from glob import glob
from os.path import basename
from os.path import dirname
from os.path import join
from os.path import splitext

from setuptools import find_packages
from setuptools import setup


def read(*names, **kwargs):
    return io.open(
        join(dirname(__file__), *names),
        encoding=kwargs.get("encoding", "utf8")
    ).read()


def remove_rst_roles(text):
    return re.sub(r':[a-z]+:`~?(.*?)`', r'``\1``', text)


def expand_includes(text, path='.'):
    """Recursively expands includes in given text."""
    def read_and_expand(match):
        filename = match.group('filename')
        filename = join(path, filename)
        text = read(filename)
        return expand_includes(
            text, path=join(path, dirname(filename)))

    return re.sub(r'^\.\. include:: (?P<filename>.*)$',
                  read_and_expand,
                  text,
                  flags=re.MULTILINE)


setup(
    name="processor",
    version="0.6.0",
    license="BSD",
    description="A microframework to build source -> filter -> action workflows.",
    long_description=remove_rst_roles(expand_includes(read('README.rst'))),
    author="Alexander Artemenko",
    author_email="svetlyak.40wt@gmail.com",
    url="https://github.com/svetlyak40wt/python-processor",
    packages=find_packages("src"),
    package_dir={"": "src"},
    py_modules=[splitext(basename(path))[0] for path in glob("src/*.py")],
    include_package_data=True,
    zip_safe=False,
    classifiers=[
        # complete classifier list: http://pypi.python.org/pypi?%3Aaction=list_classifiers
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: BSD License",
        "Operating System :: Unix",
        "Operating System :: POSIX",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.3",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: Implementation :: CPython",
        "Programming Language :: Python :: Implementation :: PyPy",
        "Topic :: Utilities",
    ],
    keywords=[
        'processing', 'devops', 'imap', 'rss', 'twitter'
    ],
    install_requires=[
        'hy',
        'twiggy-goodies',
    ],
    extras_require={
        'sources.imap': ['IMAPClient'],
        'sources.twitter': ['requests-oauthlib'],
        'sources.github': ['requests'],
        'outputs.rss': ['feedgen'],
        'outputs.slack': ['requests'],
        'outputs.xmpp': ['sleekxmpp'],
        # 'feedparser',
        # 'python-dateutil',
    },
    entry_points={
        "console_scripts": [
            "processor = processor.__main__:main"
        ]
    },
)
