FactoryBot.define do
  factory :car_type do
    name {Faker::Name.first_name}
  end
end
