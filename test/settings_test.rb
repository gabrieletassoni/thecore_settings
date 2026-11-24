require "test_helper"

# The Settings.ns(...) DSL every Thecore app reads its runtime configuration through.
class SettingsTest < ActiveSupport::TestCase
  test "a value set through the DSL is stored as one row in its namespace" do
    Settings.ns(:smtp).host = "mail.example.com"

    row = ThecoreSettings::Setting.find_by!(ns: "smtp", key: "host")
    assert_equal "mail.example.com", row.raw
    assert_equal "string", row.kind
  end

  test "the same key in two namespaces holds two independent values" do
    Settings.ns(:a).color_name = "red"
    Settings.ns(:b).color_name = "blue"
    Settings.unload!

    assert_equal "red", Settings.ns(:a).color_name
    assert_equal "blue", Settings.ns(:b).color_name
  end

  test "an unnamed namespace is main" do
    Settings.title = "Hello"

    assert ThecoreSettings::Setting.exists?(ns: "main", key: "title")
  end

  test "reading a missing key creates it with the given default" do
    assert_equal 30, Settings.ns(:jobs).get(:timeout, kind: "integer", default: "30").value
    assert ThecoreSettings::Setting.exists?(ns: "jobs", key: "timeout", kind: "integer")
  end

  test "integer, float, boolean and yaml values come back typed" do
    ns = Settings.ns(:typed)
    ns.set(:retries, "3", kind: "integer")
    ns.set(:ratio, "0.5", kind: "float")
    ns.set(:active, "true", kind: "boolean")
    ns.set(:hosts, ["a", "b"], kind: "yaml")
    Settings.unload!

    ns = Settings.ns(:typed)
    assert_equal 3, ns.retries
    assert_in_delta 0.5, ns.ratio
    assert_equal true, ns.active
    assert_equal ["a", "b"], ns.hosts
  end

  test "an invalid value is refused and not stored" do
    assert_raises(ThecoreSettings::PersistenceException) { Settings.ns(:bad).set(:count, "abc", kind: "integer") }
    assert_raises(ThecoreSettings::PersistenceException) { Settings.ns(:bad).set(:to, "not an email", kind: "email") }

    assert_not ThecoreSettings::Setting.exists?(ns: "bad")
  end

  test "an unknown kind is refused" do
    setting = ThecoreSettings::Setting.new(ns: "main", key: "x", kind: "nope", raw: "1")

    assert_not setting.valid?
    assert setting.errors[:kind].any?
  end

  test "a disabled setting reads as its kind's empty value" do
    Settings.ns(:flags).set(:limit, "10", kind: "integer")
    ThecoreSettings::Setting.find_by!(ns: "flags", key: "limit").update!(enabled: false)
    Settings.unload!

    assert_equal 0, Settings.ns(:flags).limit
  end

  test "the DSL memoizes a namespace until unload! (read the row when it must be fresh)" do
    Settings.ns(:cache).value_name = "old"
    ThecoreSettings::Setting.find_by!(ns: "cache", key: "value_name").update!(raw: "new")

    assert_equal "old", Settings.ns(:cache).value_name
    Settings.unload!
    assert_equal "new", Settings.ns(:cache).value_name
  end

  test "apply_defaults! loads a YAML file without overwriting values already set" do
    Settings.ns(:main).set(:site_name, "Customised")
    Settings.unload!

    Settings.apply_defaults!(file_fixture("defaults.yml").to_s)
    Settings.unload!

    assert_equal "Customised", Settings.site_name
    assert_equal 25, Settings.page_size
    assert_equal "noreply@example.com", Settings.ns(:mail).from_address
  end

  test "an html kind is sanitized before it is stored" do
    Settings.ns(:html).set(:banner, "<b>hi</b><script>alert(1)</script>", kind: "sanitize")

    raw = ThecoreSettings::Setting.find_by!(ns: "html", key: "banner").raw
    assert_includes raw, "<b>hi</b>"
    assert_not_includes raw, "<script>"
  end
end

# Saving a yaml setting must not monkey-patch YAML for the whole process: plain `require
# "safe_yaml"` redefines YAML.load_file with one argument, which breaks I18n's locale loading
# and any later YAML.load_file(path, **options).
class SettingsYamlIsolationTest < ActiveSupport::TestCase
  test "saving a yaml setting leaves YAML.load_file with options working" do
    Settings.ns(:typed).set(:hosts, ["a", "b"], kind: "yaml")

    loaded = YAML.load_file(file_fixture("defaults.yml").to_s, symbolize_names: true)
    assert_equal "Thecore", loaded[:main][:site_name][:value]
  end
end
