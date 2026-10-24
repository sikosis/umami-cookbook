# umami-cookbook

The community cookbook of application recipes for [umami](https://github.com/sikosis/umami), a package installer for Haiku.

Each file in `recipes/` describes one application and the GitHub release package that umami should select. The combined `catalog.json` is generated from those recipes and is the file consumed by umami.

## Add, edit or remove a recipe

- **Add:** create `recipes/<id>.json` using an existing recipe as a guide.
- **Edit:** update the matching recipe.
- **Remove:** delete the recipe. Removing a recipe does not uninstall packages already installed by users.

Only edit files under `recipes/`; do not edit `catalog.json` by hand. Pull requests validate every recipe against `schema/recipe-v1.schema.json` and reject duplicate or mismatched IDs. After a recipe change reaches `main`, GitHub Actions regenerates `catalog.json` and commits it automatically.

To generate the catalogue locally for inspection, run:

```sh
bash scripts/build-catalog.sh
```

## Catalogue URL

```text
https://raw.githubusercontent.com/sikosis/umami-cookbook/main/catalog.json
```

A recipe may be listed before its first package is published. It becomes installable when a stable GitHub release provides an asset matching `asset_pattern` for the machine architecture.

## Pantry packages

The [umami Pantry](https://github.com/sikosis/umami-pantry) holds published `.hpkg` assets for products whose source is not hosted online. Keep binaries in Pantry releases and their recipes here in the Cookbook.

Use namespaced release tags such as `v1.0-getback`. A Pantry recipe points to `sikosis/umami-pantry` and adds:

```json
"release_tag_pattern": "^v[0-9].*-getback$"
```

Umami then selects the newest stable or prerelease tag belonging to that product. Recipes without `release_tag_pattern` keep the normal one-repository-per-product behaviour.

Source-build instructions are deliberately deferred until umami's source-build stage.
