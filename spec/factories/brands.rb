FactoryBot.define do
  factory :brand do
    name {Faker::Name.first_name}
  end
end
