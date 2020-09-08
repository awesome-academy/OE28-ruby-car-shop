FactoryBot.define do
  factory :gearbox do
    name {Faker::Name.first_name}
  end
end
