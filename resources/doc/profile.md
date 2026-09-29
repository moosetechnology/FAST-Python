# Profile documentation

This document describes the tools provided by the `FAST-Python-ExtraTools` package. These tools are used by the Profile project and are **not loaded by default**: to load them, load the `Profile` group of the baseline.

```smalltalk
Metacello new
	githubUser: 'moosetechnology' project: 'FAST-Python' commitish: 'main' path: 'src';
	baseline: 'FASTPython';
	load: 'Profile'
```

## Exporting a model with its derived properties

The `FMModelExporterWithDerived` is a special exporter that, contrary to the normal exporter, also exports the derived properties of the entities. This is useful to provide a model to people not using Moose.

To export a model with its derived properties, send `#exportAsJSONWithDerived` to the model:

```smalltalk
model exportAsJSONWithDerived
```

> Warning: this export is slower than a normal export because it computes all the caches of the model. Moreover, if a property fails to be computed, it is ignored and not exported.

### Excluding some properties

Some properties can be excluded from the export by giving a blacklist to `#exportAsJSONWithDerivedBlacklist:`. The blacklist should contain the compiled method names of the properties to exclude, in the form `Class>>#selector`:

```smalltalk
model exportAsJSONWithDerivedBlacklist: #('TEntityMetaLevelDependency>>#isDead' 'TEntityMetaLevelDependency>>#fanIn' 'TEntityMetaLevelDependency>>#fanOut' 'TEntityMetaLevelDependency>>#numberOfDeadChildren' 'TEntityMetaLevelDependency>>#numberOfExternalClients' 'TEntityMetaLevelDependency>>#numberOfExternalProviders' 'TEntityMetaLevelDependency>>#numberOfInternalProviders' 'TEntityMetaLevelDependency>>#numberOfInternalClients')
```

## Unique identifier

The package adds a `#uniqueIdentifier` property to all entities. This property is a UUID, generated the first time it is accessed and then cached. It is used because the Moose ID is not fixed: it can change between two imports of the same model, so the Profile project needs a stable identifier for its entities.
