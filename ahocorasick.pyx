
from libc.stdio cimport FILE, fopen, fclose
from libc.stdlib cimport malloc, free
from libc.string cimport strlen
from cpython.string cimport PyString_AsString


cdef extern from "tap.h":
    pass

cdef extern from "msutil.h":
    ctypedef struct MEMBUF:
        pass
    ctypedef struct MEMREF:
        const char* ptr
        size_t len

    MEMBUF  chomp(MEMBUF)
    MEMBUF  slurp(const char* filename)
    MEMREF  memref(const char* text, int lent)
    MEMREF* refsplit(char* text, char sep, int* pnrefs)
    void    buffree(MEMBUF buf)

cdef extern from "_acism.h":
    cdef struct acism:
        pass

    ctypedef acism ACISM

cdef extern from "acism.h":
    ctypedef int (*ACISM_ACTION)(int strnum, int textpos, void *context)
    ACISM* acism_create(const MEMREF*, int)
    ACISM* acism_load(FILE*)
    ACISM* acism_mmap(FILE*)
    void   acism_destroy(ACISM*)
    void   acism_save(FILE*, const ACISM*)
    int    acism_scan(const ACISM* psp, const MEMREF text, ACISM_ACTION *fn, void *fndata)


#
# Aho-Corasick structure building
#

cdef ACISM* _build_from_memrefs(MEMREF* patterns, int num_patterns):
    return acism_create(patterns, num_patterns)


cdef ACISM* _build_from_string(char* string, char sep='\n'):
    cdef int num_patterns = 0
    cdef MEMREF* patterns = refsplit(string, sep, &num_patterns)
    return _build_from_memrefs(patterns, num_patterns)


cdef FILE* _open_file(const char* path, const char* mode="r"):
    cdef FILE *pfp = fopen(path, mode)
    if not pfp:
        raise IOError("Unable to open file: %s" % path)
    return pfp


#
# Processing
#

cdef int on_match(int strnum, int textpos, void* context):
    print "Match"
    return 0


cdef class AhoCorasick:

    cdef ACISM* psp

    def __dealloc__(self):
        acism_destroy(self.psp)

    def process(self, text):
        cdef MEMREF ctext = memref(text, len(text))
        acism_scan(self.psp, ctext, <ACISM_ACTION*>&on_match, NULL)

    def build_from_iterable(self, strings):
        """Build AhoCorasick from an iterable of strings. """
        cdef MEMREF* memrefs = <MEMREF *>malloc(len(strings) * sizeof(MEMREF))
        for i, string in enumerate(strings):
            memrefs[i].ptr = PyString_AsString(string)
            memrefs[i].len = len(string)
        self.psp = _build_from_memrefs(memrefs, len(strings))
        free(memrefs)

    def build_from_string(self, string, char sep='\n'):
        """Build string detector from `sep`-separated
        terms found in `string`. """
        cdef char* cstring = string
        cdef char  csep = sep
        self.psp = _build_from_string(cstring)

    def build_from_file(self, path):
        """Read a """
        with open(path, "rb") as input_dictionary:
            self.build_from_string(input_dictionary.read())

    def dump(self, path):
        cdef FILE* fp = _open_file(path, "w")
        acism_save(fp, self.psp)
        fclose(fp)

    def load(self, path):
        cdef FILE* patterns_file = _open_file(path)
        # Load structure into memory
        self.psp = acism_load(patterns_file)
        fclose(patterns_file)

    def mmap(self, path):
        cdef FILE* patterns_file = _open_file(path)
        # MMAP structure into memory
        self.psp = acism_mmap(patterns_file)
        fclose(patterns_file)
