require "lib/models/commit"
require "lib/models/history"

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :aria_current
activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end
activate :external_pipeline,
         name: :webpack,
         command: build? ?  "yarn build" : "yarn start",
         source: "tmp/dist",
         latency: 1
activate :inline_svg do |config|
  config.defaults = {
    role: "img",
  }
end
activate :syntax

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, with_toc_data: true

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

history = History.new(
  readme: repository.show("HEAD:README.md"),
  repository: repository,
  root: repository,
)

repository.tags.each do |tag|
  tag_history = History.new(
    out_of_date: true,
    readme: repository.show("#{tag.name}:README.md"),
    repository: repository,
    root: tag,
  )

  tag_history.commits.each do |commit|
    proxy(
      "/commits/#{commit.sha}/index.html",
      "/commits/commit.html",
      locals: {
        commit: commit,
        page: {
          title: commit.subject,
        },
        history: tag_history,
        render_diffs: true,
      },
      ignore: true,
    )
  end

  proxy(
    "/tags/#{tag.name}/index.html",
    "README.html",
    locals: {
      commit: repository.object(tag.name),
      contents: tag_history.readme,
      page: {
        title: tag_history.readme.lines.first,
      },
      history: tag_history,
      render_diffs: false,
    },
    ignore: true,
  )
end

proxy(
  "index.html",
  "README.html",
  locals: {
    commit: repository.object("HEAD"),
    contents: history.readme,
    page: {
      title: history.readme.lines.first,
    },
    history: history,
    render_diffs: false,
  },
  ignore: true,
)

history.commits.each do |commit|
  proxy(
    "/commits/#{commit.sha}/index.html",
    "/commits/commit.html",
    locals: {
      commit: commit,
      page: {
        title: commit.subject,
      },
      history: history,
      render_diffs: true,
    },
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
  def markdown(content)
    template = Tilt[:md].new { content }

    template.render
  end

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

configure :build do
  activate :relative_assets

  set :relative_links, true
end
