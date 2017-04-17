# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'devise'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include Devise::TestHelpers, :type => :controller
  config.include FeatureHelpers, type: :feature
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::Email::DSL

  include Warden::Test::Helpers
  Warden.test_mode!

  #
  # @custom
  #
  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    allow(SlackNotification).to receive(:notify)
  end

  #
  # @custom
  #
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  #
  # @custom
  #
  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if !driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  #
  # @custom
  #
  config.before(:each) do
    DatabaseCleaner.start
  end

  #
  # @custom
  #
  config.append_after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
end

# Shoulda::Matchers.configure do |config|
#   config.integrate do |with|
#     # Choose a test framework:
#     with.test_framework :rspec
#     # with.test_framework :minitest
#     # with.test_framework :minitest_4
#     # with.test_framework :test_unit

#     # Choose one or more libraries:
#     with.library :active_record
#     with.library :active_model
#     with.library :action_controller
#     # Or, choose the following (which implies all of the above):
#     with.library :rails
#   end
# end
