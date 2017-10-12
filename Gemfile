source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails',                    '~> 5.1.4'
gem 'pg',                       '~> 0.21'
gem 'puma',                     '~> 3.10'
gem 'rack-cors'
gem 'figaro'
gem 'active_model_serializers'

group :development, :test do
  gem 'byebug',                 platforms: [:mri, :mingw, :x64_mingw]
  gem 'awesome_print'
  gem 'awesome_rails_console'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
end

group :development do
  gem 'listen',                 '~> 3.1'
  gem 'spring'
  gem 'spring-watcher-listen',  '~> 2.0'
end

gem 'tzinfo-data'
