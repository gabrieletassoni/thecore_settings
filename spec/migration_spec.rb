# encoding: utf-8

require 'spec_helper'

describe 'Migrating from old versions' do
  it 'sets ns' do
    coll = ThecoreSettings::Setting.collection
    if coll.respond_to?(:insert_one)
      coll.insert_one({enabled: true, key: 'test', raw: '9060000000', type: 'phone'})
    else
      coll.insert({enabled: true, key: 'test', raw: '9060000000', type: 'phone'})
    end
    ThecoreSettings.migrate!
    expect(ThecoreSettings::Setting.first.key).to eq 'test'
    expect(ThecoreSettings::Setting.first.raw).to eq '9060000000'
    expect(ThecoreSettings::Setting.first.ns).to eq 'main'
    expect(ThecoreSettings::Setting.first.kind).to eq 'phone'
  end
end

