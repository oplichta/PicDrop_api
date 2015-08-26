require 'simplecov'
SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'database_cleaner'
require 'devise'
require 'omniauth'
# require 'support/omni_auth_test_helper'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '12345',
    :info => {
      :nickname => 'jbloggs',
      :email => 'joe@bloggs.com',
      :name => 'Joe Bloggs'
    },
  :credentials => {
    :token => 'CAAWV9VozJ0oBACONujwJ1DeEKO2qFQ7Xg82VJJHHtZB82gLrq5ms9njPLsKmFV0AEfXM4OQlbgkhtcvK56DCsHtJrSVqMM5NHwMqvr5Cv3q7XOJnx5QXjpIFv5fJmIMp4oskIlKGvw6RZA6LBthfnsiR1lmDeBbL9PKWgkkt1Akl0sZAqiBOAHuVGKGQNVizxaPaZBkouAZDZD',
    :expires_at => 1321747205,
    :expires => true
  }
  })
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods
  # config.include OmniAuthTestHelper
  config.use_transactional_fixtures = false
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
  config.infer_spec_type_from_file_location!
end
