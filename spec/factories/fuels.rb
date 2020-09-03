FactoryBot.define do
  factory :fuel do
    name {Faker::Name.first_name}
  end
end
