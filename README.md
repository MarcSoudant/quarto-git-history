# git-history Extension For Quarto

Generates a simple revision history table with content pulled from git tags with a quarto shortcode.

>[!TIP]
>This quarto shortcode extension is greatly inspired by [smutch/quarto-rev-history](https://github.com/smutch/quarto-rev-history).

## Installing

```bash
quarto add MarcSoudant/quarto-git-history
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

### Tagging commit

To tag a version of the document/project that you wish to include in the
revision history table, simply ensure that your changes are committed and add a git tag.

```bash
git tag 0.0.1-alpha
```

We can only recommend that you comply with the version naming according to [semantic versioning](https://semver.org/).

:::{.callout-note}
By default `git push` does not push tags to the remote git(s), to do so you can use `git push <remote> <tag_name>`.
:::

### Shortcode to use

Just insert this command line in your quarto document :

```md
{{ < git-history > }}
```

### Result

After rendering, a markdown table will be inserted with :
* tag name
* date of the last commit associated the tag a
* author of the last commit associated the tag 
* all the first-line descriptions (called *subjects*) of the corresponding git commits since last tag.

>[!WARNING]
>All this informations are based on th local git tags are used.

>[!NOTE]
>Commits with first started with "auto:" will not be printed.

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Example of result :

| version | date | author | description |
|:--------|:-----|:-------|:------------|
| 0.1.0 | 2022-12-13 | Simon Mutch | - Initial commit<br>- Working version<br>- :tv: Bump version|
| 0.2.0 | 2024-08-30 | Mars Soudant | -refactor: rev-history -> git-history |

