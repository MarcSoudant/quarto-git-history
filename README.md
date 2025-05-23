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

>[!NOTE]
>By default `git push` does not push tags to the remote git(s), to do so you can use `git push <remote> <tag_name>` or see `git config` parameter `push.followTags`.

### Shortcode to use

Just insert this command line in your quarto document :

```md
{{ < git-history > }}
```

### Result

After rendering, a markdown table will be inserted with :
* tag name
* date of the tag
* all the first-line descriptions (called *subjects*) of the corresponding git commits since last tag.

>[!WARNING]
>All these informations are based on the local git.

>[!NOTE]
>By default commits starting with "auto:" will not be printed (see "exclude parameter" section for other options)

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Example of result :

| version | date | description |
|:----|:-------|:------------------------------------|
| 0.1.0 | 2022-12-13 | - Initial commit<br>- Working version<br>- :tv: Bump version|
| 0.2.0 | 2024-08-30 | -refactor: rev-history -> git-history |
| 0.2.1 | 2024-08-30 | -Fix: Update callout in README.md<br>-Fix: Update callout in README.md |
| 0.2.2 | 2025-01-14 | -fix: add vscode files to gitignore<br>-refactor(git-history.lua): delete author + Description column wider + use creatordate instead of comitterdate<br>-Fix: Update README.md |


## `exclude` parameter

*New 0.3 feature*

`exclude` parameter change commit filter.

By default commits starting with "auto:" will not be printed. But if you want to exclude an other starting syntax use  `exclude` named parameter.


Example :

```md
{{ < git-history exclude=fix > }}
```

will exclude commits starting with **fix:**.

>[!NOTE]
>`exclude` parameter is not case dependant. Si *Fix*, *FIX*, ... will also be ignored in previous example.



`exclude` parameter is a regular expression :

```md
{{ < git-history exclude=fix|refactor > }}
```

will exclude commits starting with **fix:** or **refactor:**.


>[!NOTE]
>Quoting `exclude` parameter works too. So `{{ < git-history exclude="fix|refactor" > }}` works the same way.
