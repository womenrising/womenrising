require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Womenrising
  class Application < Rails::Application

    # auto load the lib folder
    config.autoload_paths << Rails.root.join('lib')

  end
end

