FactoryBot.define do
  factory :car_model do
    name {Faker::Name.first_name}
  end
end
