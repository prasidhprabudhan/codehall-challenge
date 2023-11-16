# frozen_string_literal: true

FactoryBot.define do
    factory :exam do
        subject { Faker::Educator.subject }
        association :college, factory: :college
    end
end