RSpec.shared_examples "create example posts" do
  let!(:user_1) {FactoryBot.create(
                   :user,
                   email: Faker::Internet.unique.email,
                   role: 0,
                   activated: true
  )}

  let!(:post) {FactoryBot.create(
                 :post,
                 user_id: user_1.id,
                 activated: true
  )}

  let!(:year_of_manufacture_1) {FactoryBot.create(:year_of_manufacture)}

  let!(:origin_1) {FactoryBot.create(:origin)}

  let!(:gearbox_1) {FactoryBot.create(:gearbox)}

  let!(:car_type_1) {FactoryBot.create(:car_type)}

  let!(:brand_1) {FactoryBot.create(:brand)}

  let!(:car_model_1) {FactoryBot.create(:car_model)}

  let!(:car) {FactoryBot.create(
                :car,
                year_of_manufacture_id: year_of_manufacture_1.id,
                origin_id: origin_1.id,
                gearbox_id: gearbox_1.id,
                car_type_id: car_type_1.id,
                brand_id: brand_1.id,
                car_model_id: car_model_1.id,
                post_id: post.id
  )}
end
