FactoryBot.define do
  factory :year_of_manufacture do
    name {Faker::Name.first_name}
  end
end
