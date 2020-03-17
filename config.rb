require "lib/models/commit"

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :aria_current
activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end
activate :syntax

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

repository_directory = Pathname(ENV.fetch("GIT_DIR", File.dirname(__FILE__)))

repository = Git.open(repository_directory)

locals = {
  history: {
    root: repository_directory.basename,
    commits: repository.log(nil).reverse_each.map do |commit|
      Commit.new(
        commit: commit,
        repository: repository,
      )
    end,
  },
  out_of_date: false,
  render_diffs: true,
  repository: repository,
}

repository.tags.each do |tag|
  commits = tag.log(nil).reverse_each.map do |commit|
    Commit.new(
      commit: commit,
      repository: repository,
    )
  end

  commits.each do |commit|
    proxy(
      "/commits/#{commit.sha}/index.html",
      "/commits/commit.html",
      locals: locals.merge(
        commit: commit,
        out_of_date: true,
        page: {
          title: commit.subject,
        },
        history: {
          root: repository_directory.basename,
          commits: commits,
        }
      ),
      ignore: true,
    )
  end
end

latest_readme = repository.show("HEAD:README.md")
proxy(
  "index.html",
  "README.html",
  locals: locals.merge(
    commit: repository.object("HEAD"),
    contents: latest_readme,
    page: {
      title: latest_readme.lines.first,
    },
    render_diffs: false,
  ),
  ignore: true,
)

locals.dig(:history, :commits).each do |commit|
  commit = Commit.new(
    commit: commit,
    repository: repository,
  )

  proxy(
    "/commits/#{commit.sha}/index.html",
    "/commits/commit.html",
    locals: locals.merge(
      commit: commit,
      page: {
        title: commit.subject,
      }
    ),
    ignore: true,
  )
end

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

helpers do
  def adjacent_commits(history, commit:)
    [nil].chain(history).chain([nil]).each_cons(3).detect do |_, middle, _|
      commit.sha == middle.sha
    end
  end
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
