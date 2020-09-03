FactoryBot.define do
  factory :color do
    name {Faker::Name.first_name}
  end
end
