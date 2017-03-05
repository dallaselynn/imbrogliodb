Imbroglio DB
------------

A Dart port of [MangoDB](https://github.com/dcramer/mangodb)

MangoDB was a true innovation, but requires gevent and other
monkey patching that inhibits true web scale and makes porting
to Python 3 difficult.

This is an implementation using Dart's native ~~async~~ webscale
tech.  It has no dependencies beyond the standard library.

Clone the repo and then ```dart bin/main.dart``` and then connect
to port 27017 and then marvel at the scalability.
