FactoryBot.define do
  factory :post do
    name {Faker::Name.first_name}
    content {Faker::Lorem.sentence(20)}
    user {FactoryBot.create :user}
  end
end
