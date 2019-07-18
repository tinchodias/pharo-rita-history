# pharo-rita-history

Several experiments with Pharo8, Roassal3, Spec2, Iceberg, and more.

## Install it

In Pharo 8:

~~~
Metacello new 
  baseline: 'Rita'; 
  repository: 'github://tinchodias/pharo-rita-history/'; 
  load.
~~~

## Execute experiments

* Code dependencies: See examples in class side of `HiMNavigator`.
* Code dependencies in Spec2 + Search: `HiMNavigatorPresenter defaultSpec`.
* Code changes: `Open Iceberg -> Select a repository -> Right click -> Repository (Cmd+R)`.
* Unified repository view (all local branches and tags together): Run `RiRepositoryPresenter hiedraExample` and other examples in this class.
* Extension to Roassal3 layout where rectangles repulse others: Run `RSRectangleRepulsionForceLayout` class side examples.


## What's rita?

It comes from Santa Rita, the name of this plant in Argentina:

![Plant](https://live.staticflickr.com/115/309565575_0945045e03_m_d.jpg)
