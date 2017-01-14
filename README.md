# github-pullrequest
Emacs package to smoothly create and checkout Github pull requests. Uses the Github access token for authorization to Github.

## Installation
First clone this repository, then update your emacs configuration file:

```lisp
(add-to-list 'load-path "~/.emacs.d/github-pullrequest") ;or whatever your path is
(require 'github-pullrequest)
```

Use [ido-ubiquitous](https://github.com/DarwinAwardWinner/ido-ubiquitous) to enable IDO.

## Usage

First time you run any command, it will ask for your Github access token. You can create a new access token under [github settings](https://github.com/settings/tokens). It is then saved in your git setting for the current repository under the key `github.token`, so you don't have to enter it next time.

### Prerequisite

The git repository you want to work with must have a remote called `origin` which is a github remote.

### New pull request

```lisp
M-x github-pullrequest-new
```

Creates a pull request with `current branch` as `head` and `master` as `base`. The title of the pull request is the branch name and there is no describing text.

### Checkout pull request

```lisp
M-x github-pullrequest-checkout
```

Lists all open pull requests in current repository. When selecting one of them, the branch for the pull request is checked out, and created if it doesn't exist.
