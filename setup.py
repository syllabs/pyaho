#! /usr/bin/env python
# -*- coding: utf-8 -*-


from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


setup(
    name="pyaho",
    version="0.1",
    description="Wrapper over aho-corasick C library",
    author="Rémi Berson",
    author_email="berson@syllabs.com",
    cmdclass={'build_ext': build_ext},
    ext_modules=[
        Extension("ahocorasick",
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
                "./aho-corasick"
            ],
            libraries=["acism"],
            library_dirs=['./aho-corasick']
        )
    ]
)
