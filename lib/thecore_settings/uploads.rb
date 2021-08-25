module ThecoreSettings
  module Uploads
    autoload :CarrierWaveUploader, "thecore_settings/storage/carrier_wave_uploader"
    autoload :ShrineUploader, "thecore_settings/storage/shrine_uploader"

    def self.paperclip_options
      if defined?(Rails)
        {}
      else
        {path: "#{File.dirname(__FILE__)}/../../uploads/:filename", url: '/uploads/:filename'}
      end
    end

    def self.included(base)
      # carrierwave
      if base.respond_to?(:mount_uploader)
        # puts "[thecore_settings] CarrierWave detected"
        # base.field(:file, type: String)
        base.mount_uploader(:file, ThecoreSettings::Uploads::CarrierWaveUploader)
        Settings.file_uploads_supported = true
        Settings.file_uploads_engine = :carrierwave
      # mongoid-paperclip
      elsif ThecoreSettings.mongoid? && ::Mongoid.const_defined?('Paperclip')
        base.send(:include, ::Mongoid::Paperclip)
        # puts "[thecore_settings] PaperClip detected"
        base.field(:file, type: String)
        base.has_mongoid_attached_file(:file, self.paperclip_options)
        if base.respond_to?(:do_not_validate_attachment_file_type)
          base.do_not_validate_attachment_file_type :file
        end

        Settings.file_uploads_supported = true
        Settings.file_uploads_engine = :paperclip
      elsif ThecoreSettings.active_record? && defined?(Paperclip)
        base.has_attached_file(:file, self.paperclip_options)
        if base.respond_to?(:do_not_validate_attachment_file_type)
          base.do_not_validate_attachment_file_type :file
        end
        Settings.file_uploads_supported = true
        Settings.file_uploads_engine = :paperclip
      elsif ThecoreSettings.active_record? && defined?(Shrine)
        Settings.file_uploads_supported = true
        Settings.file_uploads_engine = :shrine
        base.send(:include, ShrineUploader::Attachment(:file))
      elsif ThecoreSettings.mongoid? && ::Mongoid.const_defined?('Shrine')
        base.send(:include, ::Mongoid::Document)
        base.send(:include, ShrineUploader::Attachment(:file))
        base.field(:file_data, type: String)
        Settings.file_uploads_supported = true
        Settings.file_uploads_engine = :shrine
      else
        # puts "[thecore_settings] Uploads disabled"
      end
    end
  end
end

