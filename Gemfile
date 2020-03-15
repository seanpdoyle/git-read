source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'middleman', '~> 4.2'
gem 'middleman-aria_current', github: "thoughtbot/middleman-aria_current", branch: "sitemap"
gem 'middleman-autoprefixer', '~> 2.7'
gem 'middleman-syntax'

gem 'git'
gem 'redcarpet'
gem 'tzinfo-data', platforms: [:mswin, :mingw, :jruby, :x64_mingw]
gem 'wdm', '~> 0.1', platforms: [:mswin, :mingw, :x64_mingw]


group :test do
  gem 'capybara', require: 'capybara/minitest'
  gem 'webdrivers'
  gem 'selenium-webdriver'
end
