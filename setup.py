#! /usr/bin/env python
# -*- coding: utf-8 -*-


from setuptools import setup, Extension
from Cython.Build import cythonize

ext = Extension(
    "pyaho",
    [
        "ahocorasick.pyx",
        "aho-corasick/acism.c",
        "aho-corasick/acism_create.c",
        "aho-corasick/acism_dump.c",
        "aho-corasick/acism_file.c",
        "aho-corasick/msutil.c"
    ],
    define_macros=[("ACISM_SIZE", "8")],
    include_dirs=[
        "./aho-corasick"
    ]
)

setup(
    name="pyaho",
    version="0.3",
    description="Wrapper over aho-corasick C library",
    author="Rémi Berson",
    author_email="berson@syllabs.com",
    ext_modules=cythonize(ext)
)
