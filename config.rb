# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

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

repository = Git.open(
  Pathname(ENV.fetch("GIT_DIR", File.dirname(__FILE__))),
)

locals = {
  history: {
    commits: repository.log(nil).reverse_each,
  },
}

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
  def markdown(content)
    template = Tilt[:md].new { content }

    template.render
  end
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
