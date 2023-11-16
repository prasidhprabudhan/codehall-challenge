# frozen_string_literal: true

FactoryBot.define do
    factory :user do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        phone_number { Faker::PhoneNumber.phone_number }
        start_time { DateTime.now.iso8601 }
        association :college, factory: :college
        association :exam, factory: :exam
    end
end