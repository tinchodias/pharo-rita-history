# AGENTS.md

## Read first

- Read `~/.opencode/AGENTS.md` if it exists, and every file it points to. It carries the machine-wide conventions (Pharo/Tonel rules, naming, testing rules). This project file wins on conflict.

## What Rita is

A Pharo tool that visualizes git changes so a commit can be reviewed with pictures, not only text. It extends Iceberg. Two halves: a commit list on the left, a canvas + tree diff view on the right.

## Packages and entry points (`src/`)

- `BaselineOfRita` — the only baseline. Pins Iceberg to `github://pharo-vcs/iceberg:Pharo14/` with `loads: #(allTests)`.
- `Rita-Model` — headless. `RiRepository` walks an `IceLibGitRepository` into `RiElement`/`RiCommit`/`RiUncommitedWorkingCopy` decorated with `Ri*Mark`s (branch/tag/image/workdir). `RiDiffQuery` filters that diff tree.
- `RiAbstractElement` — common superclass of `RiElement` and `RiCompositeElement`. Its whole API is the two endpoints of a range: `#sourceRiElement` (older) and `#targetRiElement` (newer). It deliberately has **no** `#diff`; the existing seam is `RiDiffModel>>iceDiffFrom:`, which already owns "base + target → diff", so a second `target diffTo: source` on the model would duplicate the rule. **No selector on `RiAbstractElement` has a production sender yet** — it is the agreed seam for upcoming multi-selection, not yet wired. `RiParentDiffModel`/`RiPinDiffModel` are not redundant: they wrap a fixed base for the "compare to X" pages.
- `Rita-Roassal3` — Roassal3 canvas: `RiTorchRenderer`, `RiAestheticsModel`, `RiHighlightingController`, icon/colour visitors.
- `Rita-UI` — Spec2 presenters. App entry point: `RitaBrowserPresenter class>>open` (the `<worldMenu>` pragma in that same class registers the menu item).
  - `RiRepositoryListPresenter` → home page; `RiRepositoryPresenter` → per-repository page (commit list + commit details + notebook of diffs).
  - `RiFullDiffPresenter` is the real diff page: it pairs `RiTreeDiffPresenter` (tree) with `RiTorchDiffPresenter` (canvas) and owns the source diff widget.
- `Rita-Tests` — three test classes (`RiDiffQueryTest`, `RiRepositoryModelTest`, `RiCompositeElementTest`). **No UI test coverage exists.**

## `Rice*` is a fork of Iceberg's `Ice*` metamodel

- `RiceDiff`, `RiceDefinition`, `RiceNode`, `RiceChangeImporter`, `RicePropertyDefinition`… are a **modified copy** of Iceberg's diff metamodel: no `Rice*` class subclasses an `Ice*` class, and their superclasses are all `Rice*` or `Object`. Rita builds diffs with `RiceDiff` (from `RiElement>>diffTo:`), never `IceDiff`. The only coupling to Iceberg is at runtime (`#changesTo:`, `IceGitChange`, `MCDefinition`).
- Why, and the two deliberate model changes: `doc/RiceModel.md` (unify a class' instance side and class side into one node; split class-definition changes from comment changes).
- **`patching` protocol category = the intentional divergences** from the Iceberg original (`grep -rn "patching" src/Rita-Model`). Everything else is a verbatim copy. Put new divergences in `patching`, and re-check those methods when the Iceberg branch moves.
- Visitor protocol is Rita's own: `Rice*Definition>>accept:` sends `visitClassDefinition:`, `visitMethodNode:`, `visitPropertyDefinition:`, … to `RiIceDefinitionIconVisitor`, `RiIceOperationColorVisitor`, `RiDetailedPopupHackyVisitor`. Adding a definition kind means updating all of them.

## The 1:1 tree ↔ canvas contract (the core invariant)

- One `IceNode` = one tree row = one Roassal shape. A shape's `RSShape>>model` **is** the `IceNode`; `RiHighlightingController` indexes shapes by `IdentityDictionary` on that model. All cross-widget traffic passes IceNodes, never definitions. Preserve this or hover/selection/expand silently desync.
- The tree owns expansion. `RiFullDiffPresenter>>refreshOnModelUpdate` installs the `#block…` closures; a canvas double-click delegates *to* the tree (`#blockWhenNodeExpandToggle` → `treeDiffPresenter doToggleExpandOneLevel`). Never expand from the canvas side.
- `RiTorchModelDescriptor` is only *polymorphic to* `RSUMLClassDescriptor` (same selectors, `Object` superclass). Match that shape if you extend it.
- `RiDiffQuery>>basicTreeToQuery` builds a `RiceDiff` by hand in the `onlyConsiderChanged: false` path and never sets `writerClass`; it is marked `"FIX"`. Expect trouble there.

## Presenters are wired through a plain Dictionary "model"

`RiPresenter` has no view-model object: `model` is a `Dictionary`. Read `RiRepositoryPresenter>>refreshOnModelUpdate` and `RiFullDiffPresenter>>refreshOnModelUpdate` first — they build it. Keys: `#root`, `#repository`, `#iceDiff`, `#expandedIceNodes`, `#shadowedIceNodes`, `#diffQuery`, and closures `#blockWhenNodeSelected`, `#blockWhenNodesHighlighted`, `#blockWhenExpandedIceNodesChanged`, `#blockWhenNodeExpandAll`/`#blockWhenNodeCollapseAll`, `#blockForIterateNext`/`#blockForIterateBack`. Sub-presenters receive `model copy` plus extra keys. Add a key where the dictionary is **built** (parent), not where it is read.

## Undeclared dependencies — do not "fix" without asking

- The baseline declares only Iceberg. Roassal is deliberately **not** declared (commit d579540, "Do not load the full roassal with Rita"), yet `Rita-Roassal3` subclasses `RSAbstractUMLClassRenderer` and `Rita-UI` uses `SpRoassalPresenter`, `RSShapeFactory`, `RSCanvasController`, `RSZoomToFitCanvasInteraction`, … So the target image must already contain Roassal 3, plus Iceberg-UI (FastTable) and Spec2.
- `Rita-Model` calls into Iceberg (`#changesTo:`, `IceGitChange`, `MCDefinition` extensions) without listing it in `requires:`.
- `Rita-UI` monkey-patches third-party internals: `FTTableMorph>>beRitaContainer`, `FTTreeDataSource>>indexOfElement:`, `HiColumnController>>isReady`, `HiSimpleRenderer>>isReady`, `SpAbstractListPresenter>>selectItem:scrollToSelection:`, `RubAbstractTextArea>>removeAllSegments`. These are version-fragile — an Iceberg upgrade can break tree/hiedra rendering, and the failure will not look like an Iceberg failure.
- `RiTreeDiffPresenter` also deliberately bypasses FastTable's public API (`basicHighlightIndexes:`, `hackFastTableForSecondaryHighligthing:`). Don't "clean that up".

## Commands

- No Makefile, no lint/format config, no codegen. There is no lint/typecheck step to run.
- CI (`.github/workflows/tests.yml`) is the only automated check: `smalltalkci -s Pharo64-15 .ci.ston`, Windows only, 10 min timeout. Requires Docker running locally to reproduce.
- Bootstrap script: `scripts/build.sh` (downloads Pharo, loads the baseline from `tonel://<repo>/src`, writes `./build`). Caveats: README says `./script/build.sh` — the directory is `scripts/`; the script pins Pharo 13 while the baseline pins Iceberg's Pharo14 branch and CI runs Pharo 15, so treat it as stale and prefer your own image.
- Pharo MCP image: use the **`pharo2`** server — Pharo 15 with Rita, Iceberg (including `Iceberg-Tests` and `Iceberg-Memory`, so `RiTestCase` and its fixtures resolve) and `Iceberg-TipUI` (FastTable + Hiedra) already loaded, and in sync with this tree. Do **not** use the `pharo` server: it is a different image, Pharo 14, without Rita. Reload from the working tree after adding or editing classes, never from GitHub:
  ```smalltalk
  Metacello new
      baseline: 'Rita';
      repository: 'tonel:///absolute/path/to/pharo-rita-history/src';
      load
  ```
- Running tests: `(RiDiffQueryTest suite run)` or `(RiDiffQueryTest suite run: #test06ConsiderOnlyChangedWithFiles)` in the image; `./pharo Pharo.image test 'RiDiffQueryTest'` from the CLI; or the dedicated MCP test tool.
- Tests are git-integration heavy and create throwaway repos per test: `RiDiffQueryFixture` scripts 7 commits, `RiTestCase` uses `IceBasicRepositoryFixture inGit`. `RiRepositoryModelTest` (ancestors/children/merge/refresh) is the fast one. `RiTestCase>>deleteBranch:` has a hardcoded 500 ms `wait` with the comment "without this the image is broken after running the whole test suite" — leave it.
- **`RiDiffQueryTest` cannot run in the `pharo2` image** — it dies escaping a `Deprecation` from Iceberg's `IceClassDefinition>>asMCDefinitionWithoutMetaSide` (`Object>>deepCopy`), which `RiDiffQueryTest` does not silence. This is pre-existing and unrelated to Rita code. So running the whole `Rita-Tests` package aborts; run `RiRepositoryModelTest` and `RiCompositeElementTest` individually instead. Two other Iceberg deprecations (`AbstractFileReference>>asUrl` from `IceGitTestFactory>>remoteFileUrl`) had to be worked around in the image to get any test to run at all.
- `RiCompositeElement` **trusts its caller**: `#of:` requires a collection that is already unique and ordered the way `RiRepository>>elements` orders it (newest first), and refuses fewer than 2 elements (so a single selected commit is not a composite). It does **not** dedupe or re-sort — a mis-ordered collection silently inverts the composite (`#newestElement` is `first`, `#oldestElement` is `last`, and `#targetRiElement` is a `detect:` over the collection). Whoever builds the selection must therefore pass repository-ordered elements; row order in the UI comes from `RiRepositoryCommitsPresenter>>refreshOnModelUpdate` (`table items: self riRepository elements`), but **selection order is not row order** and nothing verifies it. There is no UI test coverage to catch a mistake here.
- Two gotchas in `RiElement`'s ancestor API, both silent-wrong-answer traps: `#ancestors` is a collection and returns an empty one for the root commit, but `#detectInAllAncestors:ifFound:` answers **the receiver** when nothing matches rather than `nil`. `#ancestorToDiffIfPresent:ifAbsent:` ignores the block and just answers the first ancestor. Prefer `ancestors detect:ifNone:`.
- UI changes cannot be covered by tests. Verify by opening `RitaBrowserPresenter` (or a single repository) in the image.

## Repo conventions

- Tonel files: class-side methods first, then instance side, alphabetical within each block. Prefer editing in the image and letting Pharo save, rather than hand-editing `.class.st`.
- Category names in `Rita-UI` double as Metacello tags: `Rita-UI-Spec2-Diff` → tag `Spec2-Diff`. Match an existing prefix when adding a class: `Spec2-Base`, `Spec2-Repository`, `Spec2-Diff`, `Spec2-Search`, `Models`, `Support`.
- Extensions to foreign classes live in `Foo.extension.st` inside the extending package, protocol `*Rita-…`.
- Known rough edges, leave alone unless asked: `RiTreeDiffPresenter2` (no senders), `RiDetailedPopupHackyVisitor`, `RiTorchDiffPresenter>>buildHelpIcon` ("Hacky"), the commented-out `showPackages` branch in `buildClassesTraitsExtensionsAndConnections`, and the `self flag: #todo. "Race…"` spots in `RiHighlightingController` / `RiElementRowBuilder`.
- README drift: it claims the World Menu item is under *Library*, but the code registers it under `#Tools`.
