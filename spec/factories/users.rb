# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }

    trait :confirmed do
      confirmed_at { 1.day.ago }
    end
  end
end
