FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    association :user, factory: :user
    association :article, factory: :article
  end
end
