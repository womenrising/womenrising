require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# leave out TestUnite because we're using RSpec

Bundler.require(*Rails.groups)

module Womenrising
  class Application < Rails::Application
    # auto load the lib folder
    config.autoload_paths << Rails.root.join('lib')

    config.generators do |g|
      g.test_framework :rspec
      g.assets = false
      g.helper = false
      g.view_specs = false
    end
  end
end
