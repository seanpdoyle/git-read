require "lib/models/history"

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

config[:mode] = (ENV.fetch("MODE") { build? ? "build" : "server" }).to_sym

activate :aria_current
activate :external_pipeline,
         name: :webpack,
         command: build? ?  "yarn build" : "yarn start",
         source: "tmp/dist",
         latency: 1

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
  name: repository_directory.basename,
  readme: repository.show("HEAD:README.md"),
  repository: repository,
)

history.commits.each do |commit|
  proxy(
    "/commits/#{commit.sha}/index.html",
    "/commits/commit.html",
    locals: {
      history: history,
      commit: commit,
      page: {
        title: commit.message.lines.first,
      }
    },
    ignore: true,
  )
end

proxy(
  "index.html",
  "README.html",
  locals: {
    history: history,
    commit: history.initial_commit,
    contents: history.readme,
    page: {
      title: history.readme.lines.first,
    },
  },
  ignore: true,
)

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
