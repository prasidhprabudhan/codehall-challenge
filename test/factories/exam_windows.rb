# frozen_string_literal: true

FactoryBot.define do
    factory :exam_window do
        association :exam, factory: :exam
        start_date { 10.days.ago }
        end_date { 10.days.from_now }
    end
end
