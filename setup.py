#! /usr/bin/env python
# -*- coding: utf-8 -*-


from setuptools import setup, Extension


# setuptools DWIM monkey-patch madness
# http://mail.python.org/pipermail/distutils-sig/2007-September/thread.html#8204
# From: https://pypi.python.org/pypi/setuptools_cython/
import sys
if 'setuptools.extension' in sys.modules:
    m = sys.modules['setuptools.extension']
    m.Extension.__dict__ = m._Extension.__dict__


ext = Extension(
    "ahocorasick",
    [
        "ahocorasick.pyx",
        "aho-corasick/acism.c",
        "aho-corasick/acism_create.c",
        "aho-corasick/acism_dump.c",
        "aho-corasick/acism_file.c",
        "aho-corasick/msutil.c"
    ],
    define_macros=[("ACISM_SIZE", "8")],
    extra_compile_args=[
        "-O3",
        "-Wall",
        "-Wextra",
        "-flto",
        "-march=native"
    ],
    include_dirs=[
        "/usr/local/include/python2.7",
        "/usr/include/python2.7",
        "./aho-corasick"
    ]
)


setup(
    name="pyaho",
    version="0.2",
    description="Wrapper over aho-corasick C library",
    author="Rémi Berson",
    author_email="berson@syllabs.com",
    setup_requires=['setuptools_cython'],
    ext_modules=[ext]
)
