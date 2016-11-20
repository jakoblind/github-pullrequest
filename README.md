# github-pullrequest
Emacs package to smoothly create Github pull requests.

## Installation
First clone this repository, then update your emacs configuration file:

```lisp
(add-to-list 'load-path "~/.emacs.d/github-pullrequest") ;or whatever your path is
(require 'github-pullrequest)
```

## Usage

### Prerequisite

The git repository must have a remote called `origin` which is a github remote.

### New pull request

To create a new pull request:

```lisp
M-x github-pullrequest-new
```
First time you run this command, it will ask for your Github access token. You can create a new access token under [github settings](https://github.com/settings/tokens). It is then saved in your git setting for the current repository under the key `github.token`.

This command creates a pull request with `current branch` as `head` and `master` as `base`. The title of the pull request is the branch name and there is no describing text.
