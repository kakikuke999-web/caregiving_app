ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Thread-based parallelization shares one database across threads, and
    # fixture loading (which runs disable_referential_integrity) isn't safe
    # to run concurrently against a shared DB — this reliably produces
    # PG::TRDeadlockDetected / connection pool exhaustion on this setup even
    # with only a couple of worker threads. The suite is small enough
    # (well under 10s) that running serially isn't a real cost.
    parallelize(workers: 1, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    include Devise::Test::IntegrationHelpers
    include ActionMailer::TestHelper

    # Add more helper methods to be used by all tests here...
  end
end
