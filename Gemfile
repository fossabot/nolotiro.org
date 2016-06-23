source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 4.2'
gem 'rails-i18n', '~> 4.0'
gem 'haml-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'

group :doc do
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'minitest-spec-rails'                 # test: specs style out-of-the-box
  gem 'capybara'                            # test: real user interactions
  gem 'launchy'                             # test: features - save_and_open_page helper
  gem 'factory_girl_rails', '~> 4.0'        # test: factories
  gem 'byebug'                              # dev: debugger
  gem 'spring'                              # dev: speed up things
  gem 'commands'                            # dev: rake commands in console
  gem 'web-console', '~> 2.0'               # dev: better errors
  #gem 'better_errors'                       # dev: better errors
  #gem 'binding_of_caller'                   # dev: better errors
  gem 'mailcatcher'                         # dev: mailbox
  gem 'bullet'                              # dev: n+1 query problem alert
end

group :test do
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 2.0'
  gem 'database_cleaner', '~> 1.5'
end

group :production, :staging do 
  gem 'airbrake', '~> 4.0'                  # exception notification
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'


# deploy
group :development do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-ci'
  gem 'capistrano-pending'
end

gem 'newrelic_rpm'                                  # monitoring
gem 'actionpack-page_caching'                       # caching
gem 'actionpack-action_caching'                     # caching
gem 'unicorn'                                       # webserver
gem 'mysql2', '~> 0.4.4'                            # database adapter
gem 'thinking-sphinx'                               # sphinxsearch
gem 'redis-rails'                                   # redis cache
gem 'sidekiq'                                       # job workers
gem 'sinatra', require: false
gem 'slim'

gem 'geoplanet'                                     # yahoo woeid geoplanet
gem 'maxminddb'                                     # geolite city v2
gem 'will_paginate', '~> 3.0'                       # pagination
gem 'devise'                                        # users
gem 'devise-i18n'                                   # devise translations
gem 'omniauth'                                      # users login with providers
gem 'omniauth-facebook'                             # users login with facebook
gem 'omniauth-google-oauth2'                        # users login with google
gem 'cancancan', '~> 1.10'                          # authorization# authorization# authorization
gem 'paperclip', '~> 4.0'                           # images
gem 'delayed_paperclip'                             # images processing in bacground
gem 'recaptcha', :require => 'recaptcha/rails'      # captcha
gem 'ipaddress'                                     # ip address validation
gem 'localeapp'                                     # i18n interface
gem 'activeadmin', github: 'activeadmin'            # admin backend
gem 'active_skin'                                   # admin backend skin
gem 'rakismet'                                      # antispam
gem 'font-awesome-rails'                            # font-awesome icons
gem 'faker'
gem 'ruby-progressbar'

gem 'mailboxer', github: 'mailboxer'                # messaging

gem 'bootstrap-sass', '~> 3.3'
