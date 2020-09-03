FactoryBot.define do
  factory :condition do
    name {Faker::Name.first_name}
  end
end
