# Set up gems listed in the Gemfile.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../../Gemfile", __dir__)

require "bundler/setup" if File.exist?(ENV["BUNDLE_GEMFILE"])
$LOAD_PATH.unshift File.expand_path("../../../lib", __dir__)

# Postgres is the only DB target: tests run on Postgres, like every Thecore gem and host app.
# DATABASE_URL overrides database.yml, and the devcontainer points it at the host app's dev DB,
# which this dummy app's migrations would clobber. Keep DATABASE_URL's server/credentials, but
# always use this gem's own per-environment database.
if ENV["DATABASE_URL"].to_s.start_with?("postgres")
  ENV["DATABASE_URL"] = ENV["DATABASE_URL"].sub(%r{/[^/?]*(?=\?|\z)}, "/thecore_settings_#{ENV.fetch("RAILS_ENV", "development")}")
end
