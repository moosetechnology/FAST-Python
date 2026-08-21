# AGENTS.md

Always read and follow the coding conventions in `~/.opencode/AGENTS.md`.

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
  FAST-Python-Model-Tests/       -- Model-level tests
  FAST-Python-Tools/             -- Importer, CFG, local resolver, SSA, TreeSitter visitor
  FAST-Python-Tools-Tests/       -- Tests for tools (importer, CFG, resolver, SSA)
```

**Baseline groups:**
- `Core` = Model + Tools
- `Generator` = Model-Generator only
- `Tests` = Model-Tests + Tools-Tests

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

## Testing

- **Base test class**: `FASTPythonAbstractTestCase` (in Tools-Tests) -- provides a `parse:` helper that wraps `FASTPythonImporter` with error reporting.
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
