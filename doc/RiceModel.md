# Why a custom metamodel (why not just Iceberg's)?

A short note about why Rita uses a variant of the Iceberg's model. The classes have the `Rice` prefix.
These changes were chosen to maintain a strict 1:1 correspondence between tree items and Roassal shapes, enabling consistent expand/contract behavior and direct, mirrored interactions (hover/selection).

## Design goal: a strict 1:1 mapping between visuals and tree items
While using the tool I found it very helpful to keep a one-to-one correspondence between each visual element on the Roassal canvas and each node in the tree view. This 1:1 mapping improves discoverability and navigation, especially for large changes where I often look at the visualization with my eyes but interact with the tree with my hands (clicks and keyboard).

The 1:1 mapping is enforced across:
- expand/contract behavior (package/class expansion is shown the same way in both widgets),
- hover highlighting (hovering a tree item highlights the matching shape in the canvas with the same light color),
- selection (clicking a tree item selects and highlights the corresponding shape, and vice-versa).

This consistent mapping motivated two small model changes compared to Iceberg's metamodel.

## 1. Unify instance- and class-side nodes for classes (and traits)
Iceberg represents the instance side and the class side of a class as separate nodes. To preserve 1:1 between tree item and visual shape I chose to unify the two sides into a single node representing the whole class (or trait).

Why unify?
- When a package is contracted the tree and canvas should both stop showing the class; if instance and class sides are separate nodes the widgets could get out of sync or require two shapes per class.
- A single node lets us show an UML-like box for the class on the canvas and a single corresponding tree item.

Alternative considered
- Keep Iceberg's two nodes and render two separate Roassal shapes (one per side). That is a valid approach, but I preferred the unified-node approach for a simpler, clearer tree/visual mapping.

## 2. Split class definition changes from class comment changes
In Iceberg, changes to the class definition and the class comment are handled together. For the visualization and tree I wanted to differentiate these concerns: instvars, classvars, shared pool entries, and class comment should be distinct, addressable items with distinctive icons.

Why split them?
- It allows showing separate icons in the canvas (and separate tree nodes) for instvar, classvar, shared pool, and class comment changes.
- Keeps the 1:1 rule: each conceptual item (e.g., an instvar) has a corresponding tree node and a corresponding Roassal element.

## UX benefits
- Predictable expand/contract: collapsing a package hides the exact same set of items in both views.
- Tight interaction sync: hover and selection are mirrored with identical highlighting, which reduces cognitive load when switching between canvas and tree.
- Better confidence when navigating large diffs: the tree is often faster to traverse (keyboard/click), while the canvas gives spatial context—keeping them synchronized makes both stronger together.

(Martín)