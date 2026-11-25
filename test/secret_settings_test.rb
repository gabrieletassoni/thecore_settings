require "test_helper"

# Secret settings (host ADR 0046 point 10, host Odoo #6084): a setting whose key names a secret is
# write-only. Its value is still read by the code that needs it (SMTP, SQL Server, SMB, Web Push),
# but no serialization returns it, and saving it blank keeps the stored value.
class SecretSettingsTest < ActiveSupport::TestCase
  test "keys that name a secret are secret, the others are not" do
    %w[password admin_password private_key client_secret secret access_token api_key passwd].each do |key|
      assert ThecoreSettings::Setting.secret_key?(key), "#{key} should be secret"
    end
    %w[user_name username public_key address token_expiry contact_email max_messages_per_subscriber].each do |key|
      refute ThecoreSettings::Setting.secret_key?(key), "#{key} should not be secret"
    end
  end

  test "saving a secret blank keeps the stored value; a new value replaces it" do
    setting = ThecoreSettings::Setting.create!(ns: "smtp", key: "password", raw: "s3cret")

    setting.update!(raw: "")
    assert_equal "s3cret", setting.reload.raw

    setting.update!(raw: nil)
    assert_equal "s3cret", setting.reload.raw

    setting.update!(raw: "n3w")
    assert_equal "n3w", setting.reload.raw
  end

  test "saving a non-secret blank still clears it" do
    setting = ThecoreSettings::Setting.create!(ns: "smtp", key: "user_name", raw: "mailer")

    setting.update!(raw: "")
    assert_equal "", setting.reload.raw
  end

  test "the value of a secret is never serialized, the other settings are unchanged" do
    secret = ThecoreSettings::Setting.create!(ns: "vapid", key: "private_key", raw: "PRIVATE-PEM")
    plain = ThecoreSettings::Setting.create!(ns: "vapid", key: "public_key", raw: "PUBLIC-PEM")

    [secret.to_json, secret.as_json(only: [:raw]).to_json, secret.as_json(methods: [:value, :attributes, :raw_was]).to_json,
     ThecoreSettings::Setting.where(ns: "vapid").to_json].each do |json|
      refute_includes json, "PRIVATE-PEM"
    end
    assert_nil secret.as_json["raw"]
    assert_equal "PUBLIC-PEM", plain.as_json["raw"]
    assert_equal "PRIVATE-PEM", ThecoreSettings::Setting.find_by(ns: "vapid", key: "private_key").raw
  end
end
