# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

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
    commits: repository.log(nil).reverse_each,
  },
}

proxy(
  "index.html",
  "README.html",
  locals: locals.merge(
    commit: repository.object("HEAD"),
    page: {
      title: repository.object("HEAD:README.md").contents.lines.first,
    },
  ),
  ignore: true,
)

locals.dig(:history, :commits).each do |commit|
  proxy(
    "/commits/#{commit.sha}/index.html",
    "/commits/commit.html",
    locals: locals.merge(
      commit: commit,
      page: {
        title: commit.message.lines.first,
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
