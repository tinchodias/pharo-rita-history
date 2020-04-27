# Rita

[![Build Status](https://travis-ci.org/tinchodias/pharo-rita-history.png)](http://travis-ci.org/tinchodias/pharo-rita-history)

This repository is home of several experiments on understanding of code changes with Pharo.

## Install

In Pharo 8/9:

~~~Smalltalk
Metacello new 
  baseline: 'Rita'; 
  repository: 'github://tinchodias/pharo-rita-history/'; 
  load.
~~~

## Execute

~~~Smalltalk
RiRootPresenter open
~~~

## Old experiments 

The following are experiments stored in this repository that (some of them might still run)

* Code dependencies: See examples in class side of `HiMNavigator`.
* Code dependencies in Spec2 + Search: `HiMNavigatorPresenter defaultSpec`.
* Code changes: `Open Iceberg -> Select a repository -> Right click -> Repository (Cmd+R)`.
* Unified repository view (all local branches and tags together): Run `RiRepositoryPresenter hiedraExample` and other examples in this class.
* Extension to Roassal3 layout where rectangles repulse others: Run `RSRectangleRepulsionForceLayout` class side examples.
* UML-like view of a commit: `RiUMLClassBuilder`


## What's *rita*?

It comes from Santa Rita, the name of [this plant](https://es.wikipedia.org/wiki/Bougainvillea) in Argentina:

![Plant](https://live.staticflickr.com/115/309565575_0945045e03_m_d.jpg)
