module ThecoreSettings
  module Mongoid
    extend ActiveSupport::Concern
    included do
      include ::Mongoid::Document
      include ::Mongoid::Timestamps::Short

      store_in collection: "thecore_settings"
      field :enabled, type: ::Mongoid::VERSION.to_i < 4 ? Boolean : ::Mongoid::Boolean, default: true
      field :kind, type: String, default: ThecoreSettings.types.first
      field :ns, type: String, default: 'main'
      field :key, type: String
      field :raw, type: String
      field :label, type: String
      index({ns: 1, key: 1}, {unique: true, sparse: true})
    end
  end
end

