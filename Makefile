

all: install

install: aho-corasick/libacism.a
	python setup.py install

aho-corasick/libacism.a:
	make -C aho-corasick

test: install
	python test_wrapper.py

clean:
	@rm -frv build
	@rm -frv dist
	@rm -fv ahocorasick.c
