FactoryBot.define do
  factory :car do
    year_of_manufacture {FactoryBot.create :year_of_manufacture}
    gearbox {FactoryBot.create :gearbox}
    car_type {FactoryBot.create :car_type}
    car_model {FactoryBot.create :car_model}
    color {FactoryBot.create :color}
    number_of_seat {FactoryBot.create :number_of_seat}
    brand {FactoryBot.create :brand}
    condition {FactoryBot.create :condition}
    fuel {FactoryBot.create :fuel}
    origin {FactoryBot.create :origin}
    price {Faker::Number.within(range: 0..100000)}
    mileage {Faker::Number.within(range: 0..100000)}
    post {FactoryBot.create :post}
  end
end
