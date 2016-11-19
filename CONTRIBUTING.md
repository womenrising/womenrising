# How to Contribute to Women Rising

## Reporting Bugs

* Submit a Github issue for your issue, assuming one does not already exist.
* Clearly describe the issue including steps to reproduce when it is a bug.

## Making Changes

* Fork, then clone the repo:

    `git clone git@github.com:your-username/womenrising.git`

* Create a topic branch from where you want to base your work.
  * This is usually the master branch.
  * Name your branch appropriately: feature/short-description, refactor/short-description, bugfix/short-description
  * Example `bugfix/refactor-peer-group-specs`


* Write tests and make your change. Make the tests pass:

    `rspec spec/`

* Make commits of logical units.
  * Check for unnecessary whitespace with `git diff --check` before committing.
  * Make sure your commit messages are in the [proper format.] [commit]


* Push to your fork and [submit a pull request][pr].

[pr]: https://github.com/womenrising/womenrising/compare/

* At this point you're waiting on us. We may suggest some changes or improvements
or alternatives.

* Some things that will increase the chance that your pull request is accepted:
  * Write tests. Your pull request will not be approved if there are no tests.
  * Follow our [style guide](https://github.com/bbatsov/ruby-style-guide).
  * Write a [good commit message][commit].


[commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
