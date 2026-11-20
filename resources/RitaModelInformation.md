# Information Rita needs to build its model

This note describes what Rita needs to know about a repository to show it. Today every piece of this information comes from [Iceberg](https://github.com/pharo-vcs/iceberg) (libgit2 for the history, Monticello for the code). It is written so that another source of the same information could be plugged in later.

Rita has two layers, and they depend on the repository source in different ways:

- **The history graph** (package `Rita-Model`: `RiRepository`, `RiElement`, `RiCommit`, `RiUncommitedWorkingCopy`, the `RiMark` subclasses, `RiCompositeElement`). It feeds the commit list on the left. It is mostly plain data.
- **The diff tree** (`RiceDiff`, `RiceNode`, the `Rice*Definition` classes and the importers; `RiDiffQuery` queries it). It feeds the tree and the canvas on the right. It is a tree of definitions (package, class, method...) where each node carries an operation (added, removed, modified). Its node kinds are shaped by Smalltalk today; section 5 states the language-neutral requirement for new sources.

## 1. The history graph

`RiRepository>>process` builds it in this order: `processCommits` (walk the history), `processCommitGraph` (link parents and children), then the marks for branches, tags, the image and the working directory.

### Per commit

| Information | Used for | Notes |
|---|---|---|
| `id` (full hash) | `commitAtSha:`, `elementByCommit` key | Unique and stable. |
| `shortId` | Rows and titles in the UI | |
| Author name, author email, committer email | Commit details; `RiCommit>>textForSignature:role:` also prints a date | Read today from the libgit commit, so a source needs name, email and date for both the author and the committer roles. |
| `comment` (full message) | UI and `shortDescription` | |
| `dateAndTime` | UI | Printed from the commit date only. |
| `ancestors` (parents, ordered) | Graph, diffs, composites | **Order matters: the first parent is the base of the diff** (`RiElement>>sourceRiElement`). A merge is diffed against its first parent only. |
| `children` | UI | Not provided by the source: `processCommitGraph` derives it from the parents. |

### Order and completeness

- The list must be ordered **newest first, and no commit may appear before its children** (today: a libgit revwalk sorted in topological order, `beSortedParentsBeforeChildren`).
- `RiCompositeElement` and `RiRepository>>elementsFrom:downTo:` trust this order and do not verify it.
- The set of commits must be closed: every parent of a listed commit must be listed too, otherwise `processCommitGraph` fails on the lookup in `elementByCommit`.

### Marks

Each mark is a `RiMark` attached to a commit element.

- **Branch mark** (`RiBranchMark`): short name, the tip commit, whether a local and/or a remote branch exists (`local`, `remote`). For a remote branch, the remote object's name is read with `remoteName`. The UI also asks the local branch to `checkout`. Branches whose name ends with `/HEAD` are ignored.
- **Tag mark** (`RiTagMark`): the tag name and its commit.
- **Image mark and workdir mark** (`RiImageMark`, `RiWorkdirMark`): the commit the working copy is based on, and whether it has uncommitted changes. When it has, Rita adds a `RiUncommitedWorkingCopy` element just before that commit (its author, comment and date print as `---`, and it has no target commit for a diff). These two marks are optional: without them `RiRepository` simply does not add them.

### Repository level

- `name` and `description`.
- A way to list the repositories (`RiRootModel class>>newWithRegisteredRepositories` reads `IceRepository registry`).
- Optional actions behind buttons: fetch, open in the system file browser, remotes (the GitHub pull request feature reads `remotes` and each remote's `host`), `checkout`, browsing a commit, and the path / package / class / method search pages (they call libgit `log` and pathspec code, see `RiRepository>>selectLibgitCommitsWithChangesAt:`).

### What the left pane really reads

`shortId`, `marks`, `comment`, the author, the date, `children`, `ancestors` and `isUncommited`. Everything else is behind an action that can be left out.

## 2. The diff tree

The entry point is `RiceDiff from: source to: target` (see `RiElement>>diffTo:`). It asks `source changesTo: target` for the list of changed files, runs `RiceChangeImporter` once for the source side and once for the target side to fill two `RiceNode` trees, merges them (`mergedTreeOf:with:`) and keeps the nodes that have changes.

### Nodes the tree has to contain

Each `RiceNode` holds one `Rice*Definition`.

- The root, directories and files (path and file contents).
- Packages (name and tags/categories).
- Classes and traits. The instance side and the class side are **one node**, a deliberate difference from Iceberg (see [the Rice model note](../doc/RiceModel.md)).
- Extensions: methods added to a class that is defined in another package, with the package name.
- Methods: owner class, whether it is on the class side, protocol, selector and source code.
- Class properties, as child nodes: every `MCClassDefinition` instance variable except `name`, `variables` and `commentStamp` (superclass name, category, type, comment, trait composition, class-side trait composition). Properties that have their default value are dropped.
- Variables, as child nodes: instance, class and pool variables.

### What each node needs

- A stable key. The merge pairs the left and right nodes by key and path.
- `contents`, the text shown in the source diff, and `leftContents` / `rightContents` on the operation.
- An `accept:` implementation that sends the visitor message for its kind (`visitClassDefinition:`, `visitMethodNode:`, ...), because the icon, colour and popup visitors in `Rita-Roassal3` rely on it.
- After the merge, an operation (addition, removal, modification, no modification), which gives the colour.

### The canvas only needs the tree

`RiTorchModelDescriptor` reads the node children by definition class, the `linesOfCode` of methods and the class name. The renderer and the highlighting work on `RiceNode` identity (one node = one tree row = one shape, see the README). So anything that produces a correct `RiceNode` tree gets the whole right pane for free.

### What Iceberg provides for this today

The importers call these on the "version" (an Iceberg commit or the working copy):

- `changesTo: otherVersion`: the changed files and packages.
- `fileSystem`: read any file as it was at that version.
- `includesPackageNamed:` and `snapshotForPackage:` (a Monticello snapshot of the package definitions).
- `writerClass` (Tonel or FileTree: `isValidPackage:`, `packageNameFromDirectory:`), `properties`, `project`.
- `loadedPackages`, and `repository subdirectory` (the directory of the repository that holds the code).
- For the working copy: the loaded packages and their modified state.

The code is read as Tonel or FileTree files and parsed into Monticello definitions, which is why this option only fits Smalltalk sources. A source that already stores entities (packages, classes, methods, variables) per commit could build the definitions directly and skip the file reading and the parsing.

## 3. Where Iceberg is wired in

- `RiRepository`: `iceRepository`, `allBranches`, `tags`, `newCommitWalk` (libgit revwalk), `workingCopy`, `LGitDiff`, `selectLibgitCommitsWithChangesAt:`.
- `RiCommit` (`iceGitCommit`, `libgitCommit`), `RiElement>>asIceObject` and `RiElement>>diffTo:`.
- `RiBranchMark` and `RiTagMark` keep Iceberg branch and tag objects.
- `RiceDiff`, `RiceChangeImporter`, `RiceGitChangeImporter`, `RiceMCPackageImporter`, `RiceMCDefinitionImporter`.
- `RiDiffModel>>iceDiffFrom:` is the single place that turns "base + target" into a diff; `RiAbstractElement` deliberately has no `diff`.
- In the UI: `RiRootModel` (registry), `RiRepositoryCommitsPresenter` (checkout, browse, GitHub pull requests), `RiPullRequest`, the search pages, and `RiCommit.extension.st`.
- Not wired to Iceberg: `Rita-Roassal3` and the tree presenters, which only see `RiceNode`.

## 4. What a new connector must provide for the diff tree

The right pane needs one thing: a `RiceDiff` whose tree is made of `RiceNode`s holding `Rice*Definition`s. A connector can supply that in two ways.

### Option A: a version object (the Iceberg way)

Implement the "version" protocol that the importers call (`changesTo:`, `fileSystem`, `includesPackageNamed:`, `snapshotForPackage:`, `writerClass`, `loadedPackages`, and the others listed in section 2). `RiceDiff from:to:` then asks the source for the changes and imports them with `RiceChangeImporter`. This path still needs Monticello definitions parsed from Tonel or FileTree files, so it only fits sources that store Smalltalk code in those formats.

### Option B: build the two trees directly (recommended for another platform)

Skip the importers. For each side of the diff, build a `RiceNode` tree whose root holds a `RiceRootDefinition`, then merge them with the public method `RiceDiff>>diff:with:` and store the result with `RiceDiff>>diffTree:`. The merge takes care of the operations (addition, removal, modification, no modification) and the views work unchanged.

Caveat: `RiceDiff` also reads `source`, `target` and the repository in some actions. `description` reads the target, `canRevertChanges` asks the source, and `codeSubdirectoryNode` and `isCodeSubdirectory:` use the repository location and subdirectory. Provide those, or make sure the actions that use them are hidden for this source.

### What each definition node must carry

- **All kinds:** `name`, a stable `key` (by default the name; the merge pairs left and right nodes by key and path), and `contents` (the text shown in the source diff). `=` and `hash` must say when two definitions are the same, because the merge uses them to decide "no modification".
- **Icon and colour:** the icon comes from `icon` on each definition. When you add a definition kind, update the visitors that receive `accept:`: `RiIceDefinitionIconVisitor`, `RiIceOperationColorVisitor` and `RiDetailedPopupHackyVisitor` (see `AGENTS.md`).
- **Packages:** name, and categories if the platform has them.
- **Types (classes, traits, and any other named type):** `name`, and one node for the type. Properties and variables are child nodes of the type. Today the canvas finds them by Smalltalk class name (`RicePropertyDefinition`, `RiceVariableDefinition`), which section 5 asks to replace with neutral kinds.
- **Extensions:** the owner type name and the package that defines the extension. This is a Smalltalk concept; other languages can leave it out.
- **Members (methods, functions):** owner type name, selector or name, and source code. `linesOfCode` is computed from the source text in the `Rita-UI` extension, so the connector only has to provide the source text. Facets such as the Smalltalk class side or protocol are optional, see section 5.
- **Files and directories** (only if the platform has files): path and contents.

### What the visual needs

- One `RiceNode` per tree row and per canvas shape. A node must not appear in two places in the tree, because the canvas maps shapes to nodes by identity (see the README).
- Children are grouped by definition kind, so the descriptor can pick out properties, variables and methods.
- Each changed item carries enough to decide its operation: the left and right definitions, and their `contents`.

### Parts you can leave out for a read-only connector

- The apply and revert methods (`install`, `addToPatcher:`, `removeFrom:` and the patcher methods) are only used to write changes back to a repository. A read-only connector can leave them unimplemented, provided the actions that call them are hidden. Check that before shipping.
- Iceberg-specific browsing (`browse`, `canBrowseReferences` on methods) works only for classes that exist in the image. For another platform, hide those actions or implement them against that platform.

## 5. Language independence

The software analysis platform backend must not depend on Pharo or Smalltalk. The model it feeds to Rita has to describe code in any language. Only the Pharo connector (Option A above) may use Smalltalk concepts.

### What is already language-neutral

- **The history graph** (section 1), except for the Iceberg calls.
- **The diff machinery:** `RiceNode` trees, the merge by key and path, the operations (`RiceAddition`, `RiceRemoval`, `RiceModification`, `RiceNoModification`), and the diff query predicates that filter by kind.
- **The canvas mapping:** one node per shape, and highlighting by node identity. It does not care what the nodes mean.

### What is Smalltalk-specific today

- **Node kinds:** the `Rice*Definition` classes encode Smalltalk concepts. Examples: the class side as a flag on methods (`classIsMeta`), method protocols, traits as a separate kind, extensions to another package's class, and the properties of a Monticello `MCClassDefinition` (superclass name, trait composition, class-side trait composition).
- **Source of truth:** the definitions are built from Monticello definitions (`mcDefinition`, `asMCDefinition`), which only exist for Smalltalk code.
- **Browsing and checks:** `browse`, `canBrowseReferences` and `canBeBrowsed` look classes up in `Smalltalk globals`. `ast`, `isUnitTest` and `isLoadable` also assume Smalltalk.
- **Canvas dispatch:** `RiTorchModelDescriptor` picks children by Smalltalk class name, so it cannot see a kind it does not know.

### What the language-neutral requirement implies

1. **Neutral node kinds.** The connector describes code with generic kinds that any language can map to: a container (repository root, directory, file), a module (package, namespace, crate, or similar), a type (class, trait, interface, struct, enum), a member (method, function, procedure), and an attribute (field, property, variable). Each node has a `kind`, a `name`, a stable `key`, `contents`, and `children`.
2. **Language facets, optional.** Language-specific information goes into an optional map of named facets on the node, for example `classSide`, `protocol`, `superclassName` or `visibility`. Views may use a facet if present and must work without it.
3. **The canvas dispatches on neutral kinds.** `RiTorchModelDescriptor` (and the class-name checks in the diff query) must select children by kind, not by Smalltalk class name. This is a change to existing code, not only to the connector.
4. **Browsing is connector-provided.** Actions such as "open this member" call the connector, or are hidden when it has none. The Smalltalk `browse` stays in the Pharo connector.
5. **Option B is the only path for the new backend.** Option A reads Monticello and cannot be language-neutral.

### Decisions to take before implementing

- Whether the existing Smalltalk kinds (`RiceClassDefinition`, `RiceMethodDefinition`, ...) are mapped onto the neutral kinds, or kept as they are and the neutral kinds added beside them.
- Where the facets live (a dictionary on each node, or subclasses per language).
- Whether the canvas and the descriptor move to neutral kinds before the new backend is built, or the new backend first produces Smalltalk-shaped nodes.
