#! /usr/bin/env sh

cython -I. ahocorasick.pyx
gcc -I ~/.local/include/python2.7 -shared -fPIC -o ahocorasick.so ahocorasick.c acism.c acism_create.c acism_dump.c acism_file.c msutil.c tap.c -O3 -pthread -flto -march=native -Wall -Wextra -DACISM_SIZE=8
# valgrind --leak-check=full --show-leak-kinds=all python test_wrapper.py
python test_wrapper.py
