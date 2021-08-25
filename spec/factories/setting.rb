# coding: utf-8

FactoryBot.define do
  factory :setting, class: ThecoreSettings::Setting do
    sequence(:key){|n| "setting_#{n}" }
    raw { "Контент 1" }
  end
end
