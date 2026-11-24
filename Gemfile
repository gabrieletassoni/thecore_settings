source 'https://rubygems.org'

# Specify your gem's dependencies in thecore_settings.gemspec
gemspec

# Test suite: a dummy app (test/dummy) on PostgreSQL only, never SQLite. The gemspec declares no
# Rails dependency (host apps bring it), so the suite pins the Rails line it is tested against.
gem "rails", "~> 7.2"
gem "pg", "~> 1.1"
# Rails 7.2's test runner breaks on minitest 6.
gem "minitest", "~> 5.25"
# JUnit XML report in CI (test/support/junit_report.rb, only when JUNIT_REPORT_DIR is set).
gem "minitest-reporters", "~> 1.8"
