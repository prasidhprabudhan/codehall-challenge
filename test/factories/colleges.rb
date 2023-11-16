# frozen_string_literal: true

FactoryBot.define do
  factory :college do
    name { Faker::University.name }
  end
end
  