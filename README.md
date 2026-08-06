# Rita

[![Tests](https://github.com/tinchodias/pharo-rita-history/actions/workflows/tests.yml/badge.svg)](https://github.com/tinchodias/pharo-rita-history/actions/workflows/tests.yml)

A tool to help understanding git code changes in Pharo IDE.
Extends [Iceberg](https://github.com/pharo-vcs/iceberg). Inspired on [Torch](http://rmod.inria.fr/archives/papers/Uqui10a-Torch-WCRE10.pdf).

![Screenshot](small.png)

### Repository view (left)

Rita presents all git branches, tags, and the _working copy_ at once. The `WORKING COPY` pseudo‑tag represents the commit loaded in the image (when present). 

### Diff view (right)

Rita keeps a strict one-to-one correspondence between each visual element on the Roassal canvas and each node in the tree view. The goal is a tight, predictable UX so you can move fluidly between seeing structure and interacting with it.

Key interaction rules
- Expand / contract: collapsing or expanding a package/class hides or shows the exact same items in both the tree and the canvas.
- Hover: moving the cursor over an item in the tree highlights the corresponding canvas shape with the same light color.
- Selection: clicking an item in the tree selects and highlights its matching shape in the canvas (and vice‑versa).
- Navigation: the tree supports fast keyboard and click navigation while the canvas provides spatial context—both stay synchronized.

UX benefits
- Predictability: both views always show the same set of items for a given expand/contract state.
- Faster, confident navigation: the tree is efficient for precise traversal; the canvas gives visual context—keeping them mirrored reduces mental switching cost.
- Clear discovery: hover and selection highlighting make it easy to find and confirm the same entity in both representations.

The strict 1:1 mapping makes the visualization and the tree work as a single, cohesive interface rather than two separate tools.

## Documentation

A short note about our [Rice code-changes model](doc/RiceModel.md).

Documentation can also be browsed via Pharo IDE -> World Menu -> Help -> Documentation Browser.

## Install

Load in Pharo 14 with:

```smalltalk
Metacello new
	baseline: 'Rita';
	repository: 'github://tinchodias/pharo-rita-history:Pharo14/src';
	load
```

Load in Pharo 13 with:

```smalltalk
Metacello new
	baseline: 'Rita';
	repository: 'github://tinchodias/pharo-rita-history:Pharo13/src';
	load
```

Then, click on `World Menu -> Library -> Rita`.

## Install via Bash script:

Alternatively, we provide a bash script that downloads Pharo and installs the project. Open a terminal, create a directory and execute:
1. `git clone https://github.com/tinchodias/pharo-rita-history.git`
2. `cd pharo-rita-history`
3. `./script/build.sh`
4. `cd build`
5. `./pharo-ui Pharo.image`

In fact, you can execute the script from other directory, no need to be there the git repository was cloned.

To start Rita, do: `cd build` and `./pharo-ui Pharo.image`.
Then, click on `World Menu -> Library -> Rita`.

---

## License

The code is licensed under [MIT](LICENSE).

## What's *rita*?

It comes from "Santa Rita", the name of [this plant](https://es.wikipedia.org/wiki/Bougainvillea) in Argentina:

![Plant](https://live.staticflickr.com/115/309565575_0945045e03_m_d.jpg)
