# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
# The dummy app has no schema of its own: build the test database from the engine's migrations.
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../db/migrate", __dir__)]
ActiveRecord::Tasks::DatabaseTasks.migrate
require "rails/test_help"
require_relative "support/junit_report"

class ActiveSupport::TestCase
  self.file_fixture_path = File.expand_path("fixtures/files", __dir__)

  # Settings memoizes namespaces per process: start every test from an empty cache.
  setup { Settings.unload! }
end
