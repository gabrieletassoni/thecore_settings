module ThecoreSettings
  module RailsAdminConfig
    def self.included(base)
      if base.respond_to?(:rails_admin)
        base.rails_admin do
          navigation_label Proc.new {I18n.t("admin.settings.label")}
          # One pretty_value for list, show and export (export_value is pretty_value): a Secret
          # setting shows only whether it is set (host ADR 0046 point 10).
          configure :raw do
            pretty_value do
              object = bindings[:object]
              if object.secret?
                object.raw.present? ? "••••••••" : "-"
              elsif object.file_kind? and !defined?(Shrine) and object.to_path.present?
                if object.file.url.blank?
                  "-"
                else
                  "<a href='#{CGI::escapeHTML(object.file.url)}'>#{CGI::escapeHTML(object.to_path)}</a>".html_safe
                end
              elsif object.image_kind? and !defined?(Shrine) and !object.file.nil?
                if object.file.url.blank?
                  "-"
                else
                  "<a href='#{CGI::escapeHTML(object.file.url)}'><img src='#{CGI::escapeHTML(object.file.url)}' /></a>".html_safe
                end
              else
                value
              end
            end
          end

          list do
            if Object.const_defined?('RailsAdminToggleable')
              field :enabled, :toggle
            else
              field :enabled
            end
            field :kind
            field :ns
            field :name
            field :raw
            if ::Settings.table_exists?
              nss = ::ThecoreSettings::Setting.pluck(:ns).uniq.map { |c| "ns_#{c.gsub('-', '_')}".to_sym }
              scopes([nil] + nss)
            end
          end

          edit do
            field :enabled
            field :label do
              read_only true
              help false
            end
            field :kind do
              read_only true
              help false
            end
            field :raw do
              partial "setting_value"
              visible do
                !bindings[:object].upload_kind?
              end
            end
            if Settings.file_uploads_supported
              field :file, Settings.file_uploads_engine do
                visible do
                  bindings[:object].upload_kind?
                end
              end
            end
          end
        end
      else
        puts "[thecore_settings] Problem: model does not respond to rails_admin: this should not happen"
      end
    end
  end
end
