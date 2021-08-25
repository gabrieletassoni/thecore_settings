module ThecoreSettings
  module Dumper
    def self.dump(path)
      ns = {}
      ThecoreSettings::Setting.each do |s|
        ns[s.ns] = {} if ns[s.ns].nil?
        ns[s.ns][s.key] = s.as_yaml
      end
      File.write(path, ns.to_yaml)
    end
  end
end
