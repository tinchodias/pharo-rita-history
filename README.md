# Rita

[![Build Status](https://travis-ci.org/tinchodias/pharo-rita-history.png)](http://travis-ci.org/tinchodias/pharo-rita-history)

This repository is home of several experiments on understanding of code changes with Pharo inspired in [Torch](http://rmod.inria.fr/archives/papers/Uqui10a-Torch-WCRE10.pdf).

![Screenshot](small.png)

## Install

In Pharo 8:

~~~Smalltalk
    Metacello new
        githubUser: 'pharo-spec' project: 'Spec' commitish: 'v0.7.0' path: 'src';
        baseline: 'Spec2';
        onConflict: [ :e | e useIncoming ];
        onUpgrade: [ :e | e useIncoming ];
        ignoreImage;
        load.

    Metacello new 
        baseline: 'Rita'; 
        repository: 'github://tinchodias/pharo-rita-history/';
        onConflictUseLoaded;
        load.
~~~

## Execute

World Menu -> Tools -> Rita

or:

~~~Smalltalk
RiRootPresenter open
~~~

---

## What's *rita*?

It comes from Santa Rita, the name of [this plant](https://es.wikipedia.org/wiki/Bougainvillea) in Argentina:

![Plant](https://live.staticflickr.com/115/309565575_0945045e03_m_d.jpg)
