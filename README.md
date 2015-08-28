pyaho
=====

Cython wrapper around the very fast aho-corasick C library, written by:

Mischa Sandberg mischasan@gmail.com

From the original README:

> ACISM is an implementation of Aho-Corasick parallel string search,
> using an Interleaved State-transition Matrix.
> It combines the fastest possible Aho-Corasick implementation,
> with the smallest possible data structure (!).

LICENSE
-------

This package use the same LICENSE as the original C implementation of the library.

GETTING STARTED
---------------

Clone repository:

```sh
$ git clone git@bitbucket.org:syllabs/pyaho.git
$ git submodule init
$ git submodule update
```

Then run `python setup.py install` to compile and install `ahocorasick` python module.

EXAMPLE
-------

```python
import ahocorasick

aho = ahocorasick.AhoCorasick()

# If `patterns.txt` contains:
#    fu
#    bar
#    baz
aho.build_from_file("patterns.txt")
aho.build_from_iterable([
    "fu",
    "bar",
    "baz"
])
aho.build_from_string("fu\nbar\nbaz")

matches = aho.process("@('-')@ fu :-) bar baz!")
# ["fu", "bar", "baz"]
```
