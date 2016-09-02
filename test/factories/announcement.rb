# frozen_string_literal: true
FactoryGirl.define do
  factory :announcement do
    transient { dismisser nil }

    message 'hello world'

    trait :acknowledged do
      after(:create) do |announcement, evaluator|
        announcement.dismissals.create!(user: evaluator.dismisser)
      end
    end

    trait :current do
      starts_at { 1.hour.ago }
      ends_at { 1.hour.from_now }
    end

    trait :expired do
      starts_at { 1.day.ago }
      ends_at { 1.hour.ago }
    end

    trait :programmed do
      starts_at { 1.hour.from_now }
      ends_at { 1.day.from_now }
    end

    current
  end
end
