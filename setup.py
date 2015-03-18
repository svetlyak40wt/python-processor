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


setup(
    name="processor",
    version="0.1.0",
    license="BSD",
    description="A microframework to build source -> filter -> action workflows.",
    long_description="%s\n%s" % (
        read("README.rst"),
        re.sub(
            ":obj:`~?(.*?)`",
            r"``\1``",
            read("CHANGELOG.rst"))),
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
        'feedparser',
        'python-dateutil',
        'IMAPClient',
        'feedgen',
        'twiggy-goodies',
        'requests-oauthlib',
    ],
    entry_points={
        "console_scripts": [
            "processor = processor.__main__:main"
        ]
    },
)
