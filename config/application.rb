require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PicDropApi
  class Application < Rails::Application
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::Session::Cookie, secret: "picdrop"
    config.middleware.use Rack::Cors do
        allow do
          origins "*"
          resource "*", headers: :any, methods: [:get, :post, :put, :delete, :options]
        end
      end
        # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    social_keys = File.join(Rails.root, 'config', 'social_keys.yml')
        CONFIG = HashWithIndifferentAccess.new(YAML::load(IO.read(social_keys)))[Rails.env]
        CONFIG.each do |k,v|
          ENV[k.upcase] ||= v
        end

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
