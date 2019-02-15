# TiddlyWiki Migrator

TiddlyWiki Migrator is a set of scripts put together to automate the migration from a TiddlyWiki (TW). It allows to export all tiddlers in a single-file HTML TiddlyWiki to multiple markdown files (one per tiddler), excluding system tiddlers.

## Motivation

### What is TiddlyWiki?
TiddlyWiki "classic" (v2.x) is an offline, self-contained html wiki, where you can create, modify and delete tiddlers.

TiddlyWiki "modern" (v5.x) is a brand new TW which can run just like v2.x or using node.js as a backend service to store/retrieve tiddlers.

No doubt, TiddlyWiki is a useful and interesting piece of software.

You can find more information on the [TiddlyWiki web](https://tiddlywiki.com).

### What is a tiddler?
A tiddler is composed by:

* a title,
* a creation date,
* a last modification date,
* a creator and modifier person name,
* zero or more tags,
* a text and
* a format (e.g. "text/x-tiddlywiki")

### Why markdown?
Markdown is a possible tiddler's type (as of new versions of TiddlyWiki).

Markdown format is commonplace on the Internet: in forums, blogs, source code repo platforms, etc.

Markdown files usually end with the .md extension and follow the Markdown text format.

## Use case

A TW user has decided to abandon the use of TiddlyWiki. For that, she wants to save all tiddlers as markdown files, one for each tiddler from her TiddlyWiki.

## Features

* Supports classic (version 2) and modern (version 5) TiddlyWikis.
* Supported tiddler formats:
    * `text/vnd.tiddlywiki` (modern TW format)
    * `text/x-tiddlywiki` (classic TW format)
    * `text/x-markdown`
* Exports to Markdown using Pandoc using options to conveniently simplify the resulting text.
* Exported Markdown files follow a safe-name policy, while keeping the name as similar to the original as possible (this includes translating special vowels to the corresponding simple ones).
* Metadata from tiddlers is exported as YFML at the beginning of each Markdown file. Metadata includes: creation date, last modification date, tags, etc.

## Dependencies

* Node.js (tested with v10.4.0)
* Npm (tested with 6.1.0)
* Pandoc (tested with 2.2.1)

## Usage

1. Clone this repository.
2. Copy your single-file html TiddlyWiki (2 or 5) in your cloned repository.
3. Rename your TW html to `wiki.html`
4. Export your tiddlers:
```
$ make
```
5. Convert all your tiddlers to Markdown:
```
$ make convert
```

Your tiddlers will be in the `markdown_tiddlers` directory.

