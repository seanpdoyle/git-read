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
