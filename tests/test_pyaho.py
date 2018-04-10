
import pytest
import pyaho


@pytest.fixture(scope='function')
def aho():
    return pyaho.AhoCorasick()


def test_from_iterable(aho):
    aho.build_from_iterable([
        b'fu',
        b'bar',
        b'baz'
    ])
    assert aho.process(b"@('-')@ fu :-) bar baz!") == [b'fu', b'bar', b'baz']
