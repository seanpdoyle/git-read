require "lib/commit_helpers"

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :aria_current
activate :syntax
activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end
activate :external_pipeline,
  name: :webpack,
  command: build? ? "./node_modules/.bin/webpack --bail" : "./node_modules/.bin/webpack --watch -d",
  source: "dist",
  latency: 1

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
ignore "/commits/commit.html"

data.history.commits.each do |id|
  proxy(
    "/commits/#{id}/index.html",
    "/commits/commit.html",
    locals: { id: id },
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
helpers CommitHelpers

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
