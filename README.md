git-read
===

Generate a website based on a project's Git history.

* Serve the project's `README.md` as the homepage
* Index the history through its commits
* Transforms commit messages HTML through a syntax-aware Markdown parser
* Display the commits alongside their code changes

Command-line Interface
---

Once installed, make sure that the `bin/git-read` executable is available on
your path so that the [`git` program can invoke it as a subcommand][subcommand].

To learn of the ways to to invoke the command, execute `git read --help`:

```
usage: git read [--help] [-v|--verbose] [-s|--server|--serve]
                [-g | --git-dir <path>] [-o | --output-dir <path>]

Generate HTML from your project's Git history

OPTIONS

      --output-dir
          specify the directory where the site will be built

      --git-dir
          specify the parent directory of the project's .git/ directory

      --verbose
          print debugging information during the build process

      --server
          build and serve assets with a server available at
          http://127.0.0.1:4567

      --help
          generate this help output
```

[subcommand]: http://mirrors.edge.kernel.org/pub/software/scm/git/docs/howto/new-command.html

Revising a Project's History
---

If you're consuming this tool and using it to tell the story of your
project's origins and growth, you might be tempted to become a bit of a
revisionist historian.

This might come as a shock, but this project was not perfected
implemented from the start, and is in fact the result of countless
[`pick`, `squash`, `reword`, `fixup`, and `drop` rebase
operations][rebase].

While this can be harmless for pre-released projects, rewriting history
once the resulting website is deployed and publicized would result in
[`404`s and broken URLs][404].

To counteract this, `git-read` will include and compile pages for any
commits that are [`git tag`-ed][git-tag], along with the rest of their
history.

[rebase]: https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History#_changing_multiple
[404]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/404
[git-tag]: https://git-scm.com/book/en/v2/Git-Basics-Tagging
