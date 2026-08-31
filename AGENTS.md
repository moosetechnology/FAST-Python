# AGENTS.md

Always read and follow the coding conventions in `~/.opencode/AGENTS.md` if present.

## What This Is

A **Pharo Smalltalk** project (not Python) that provides a Famix AST representation for Python code, built on TreeSitter. Part of the [moosetechnology/FAST](https://github.com/moosetechnology/FAST) ecosystem.

Source code format: **Tonel** (all source in `src/`).

## Build & Test

This is a Pharo Smalltalk project. There are no npm/pip/make commands.

**Install dependencies in a Pharo image:**
```smalltalk
Metacello new
  githubUser: 'moosetechnology' project: 'FAST-Python' commitish: 'main' path: 'src';
  baseline: 'FASTPython';
  load
```

**CI command (what actually runs):**
```bash
smalltalkci -s Pharo64-13   # or Pharo64-14
```
CI is defined in `.github/workflows/tests.yml`. Tests run via `smalltalkci` using the `smalltalk.ston` spec. Coverage is collected in lcov format for `FAST-Python.*` packages.

There is no local test runner script outside of `smalltalkci`. You need a Pharo image with the project loaded to run tests interactively.

## Package Structure

```
src/
  BaselineOfFASTPython/          -- Metacello baseline (dependency & group definitions)
  FAST-Python-Model-Generator/   -- Metamodel generator (Famix code generation)
  FAST-Python-Model/             -- Generated model classes (FASTPy*), do NOT edit by hand
  FAST-Python-Tools/             -- Importer, CFG, local resolver, SSA, TreeSitter visitor, variable-analysis extensions
  FAST-Python-Tools-Tests/       -- All tests (tags: Core = abstract test case, Model = model tests, Analysis = variable-analysis tests)
```

**Baseline groups:**
- `Core` = Model + Tools
- `Generator` = Model-Generator only
- `Tests` = Tools-Tests only (the former Model-Tests package was merged into Tools-Tests)

**Dependencies** (from baseline):
- `FAST` v3: `github://moosetechnology/FAST:v3/src` (loads `'All'` group)
- `TreeSitter` v2.0.0: `github://Evref-BL/Pharo-Tree-Sitter:v.2.0.0/src`

## Critical: Model Files Are Generated

`FAST-Python-Model/` contains ~130 generated class files (`FASTPy*`). These are produced by `FASTPythonMetamodelGenerator` in `FAST-Python-Model-Generator/`. **Do not edit model files directly** -- edit the generator and re-run it. The generator also produces a visitor trait (`FASTPyTVisitor`).

## Key Entry Points

| Class | Role |
|-------|------|
| `FASTPythonImporter` | Parse Python source string or file → FAST model. Extends `TSFASTAbstractImporter`. |
| `FASTPythonTreeSitterVisitor` | Walks TreeSitter CST → builds FAST model. 1100+ lines, the core import logic. |
| `FASTPythonCFGVisitor` | Builds control flow graph. Uses `FASTTCFGUtility` trait from FAST. |
| `FASTPythonLocalResolverVisitor` | Links entity usages to their local declarations (scope-aware). |
| `FASTPythonSSAVisitor` | SSA transform. Uses `FASTCFGTVisitor` trait from FAST. Requires local resolution first. |
| `FASTPythonMetamodelGenerator` | Generates the Famix metamodel. Run via `FASTPythonMetamodelGenerator new generate`. |

**Typical analysis pipeline:**
```smalltalk
model := FASTPythonImporter parseFile: aFile.
FASTPythonLocalResolverVisitor resolve: model module.
model allFunctionDefinitions first cfg.          "CFG"
FASTPythonSSAVisitor resolve: model allFunctionDefinitions first.  "SSA (after resolution)"
```

### Variable-analysis API

- Python-specific variable APIs (`usedVariables`, `isResolvedVariable`, `transitiveAssignedExpressions`, `transitiveAssignedExpressionsMap`, `internalAccesses`, `allNodesUsingMe`, `statementsUsingMe`, `allNodesUsingMyVersion`, `statementsUsingMyVersion`) are single implementations on `FASTPyEntity` in `src/FAST-Python-Tools/FASTPyEntity.extension.st` (protocol `*FAST-Python-Tools`). The transitive ones require SSA resolution; the others require local resolution. The `*MyVersion` variants also require SSA.
- Contrast: FAST-level helpers (`versionWriteAccesses`, `assignedExpressionsMap`, `versionAccesses`, ...) follow a mass-extension convention -- one identical copy per FAST class in protocol `*FAST-Core-Tools`, living in the FAST dependency repo, not here.

## Testing

- **Base test class**: `FASTPythonAbstractTestCase` (in Tools-Tests, tag `Core`) -- provides a `parse:` helper that wraps `FASTPythonImporter` with error reporting. The `model` instance variable has no accessor.
- **Variable-analysis tests**: `FASTPythonVariablesAnalysisTest` is a slim base providing `parseAndResolve:` (parse + local resolution + SSA). Four subclasses in tag `Analysis`: `FASTPythonAssignedExpressionsInVariablesTest`, `FASTPythonIsResolvedVariablesTest`, `FASTPythonUsedVariablesTest`, `FASTPythonInternalAccessesTest`. Since each class tests a single concept, test methods use the plain `tests` protocol -- no specialized protocols.
- **Documentation**: `resources/doc/analysis.md` documents the local resolver, SSA, shadowing and variable-query APIs. Convention: questions are written as bold questions without new TOC entries, and only implemented API is documented.
- **Importer tests**: `FASTPythonImporterTest` extends `TSFASTAbstractImporterTest` (from TreeSitter). The test file is ~53k lines -- generated tests for every AST node type. Test generation snippet is in the class comment.
- **CFG/Resolver/SSA tests**: `FASTPythonCFGTest`, `FASTPythonLocalResolverTest`, `FASTPythonSSATest`.

## Gotchas

- **TreeSitter python grammar version matters**: After v0.25, expression statements were removed from the tree. If tests fail unexpectedly, check your `tree-sitter-python` version first (see README).
- **Pharo 13 is the primary target**; Pharo 14 is also tested. The baseline references `FAST:v3` which requires Moose 13.
- **The importer uses the master branch** of `TSLibrariesPython` (hardcoded in `FASTPythonTreeSitterVisitor class >> initialize`).
- **`expression --|> statement`**: In Python, expressions can be expression statements. This is reflected in the model hierarchy and affects how the visitor processes nodes.
- **CFG uses `FASTTCFGUtility`** from FAST (the parent project). SSA uses `FASTCFGTVisitor`. These traits define the core graph traversal protocol.
- **Local resolver scope management**: The resolver maintains a `scopes` stack. Shadowing is handled by checking entity kind consistency (same kind = shared declaration, different kind = new declaration).
- **Python 3 only for resolver**: The local resolver is Python 3 scoped. Python 2 comprehension scoping (no scope) is not supported (issue #26).
- **Non-local declarations are not deduplicated**: Each access to an unknown field creates a separate `FASTNonLocalDeclaration` (issue #26 in the repo).
- **In-image method installation**: the MCP `pharo_method_compile` can be blocked by critiques (e.g. `ReDeadBlockRule`). Fallback: `Behavior>>compile:classified:` with method source **without** the outer `[ ]` brackets -- with brackets the body parses as an inner block and a silent no-op wrapper method gets installed. Use CR line returns (see global conventions).
- **`assertCollection:hasSameElements:` is multiplicity-insensitive** in current images (`#(a a)` vs `#(a)` passes) -- add explicit `size` assertions to catch duplicates.
- **`model` ivar of `FASTPythonAbstractTestCase` has no accessor** -- in DoIt/evaluate code use `instVarNamed: #model`.
