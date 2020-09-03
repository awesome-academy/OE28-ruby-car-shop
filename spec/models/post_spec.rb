require "rails_helper"
require "spec_helper"

RSpec.describe Post, type: :model do
  let!(:post) {FactoryBot.build :post}
  let!(:post_fail) {FactoryBot.build :post, name: ""}

  describe "Validations" do
    context "when valid object" do
      it { expect(post.valid?).to eq true }
    end

    context "when invalid object" do
      it { expect(post_fail.valid?).to eq false }
    end
  end

  describe "Associations" do
    it { is_expected.to have_one(:car).dependent(:destroy) }
    it { is_expected.to have_many(:favorite_lists).dependent(:destroy) }
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe "Scopes" do
    include_examples "create example posts"

    describe ".by_user_id" do
      context "when nil params" do
        it { expect(Post.by_user_id(nil).size).to eq(Post.all.size) }
      end

      context "when valid params" do
        it { expect(Post.by_user_id(user_1.id).size).to eq(1) }
      end
    end

    describe ".by_post_id" do
      context "when nil params" do
        it { expect(Post.by_ids(nil).size).to eq(Post.all.size) }
      end

      context "when valid params" do
        it { expect(Post.by_ids(post.id).size).to eq(1) }
      end
    end

    describe ".by_year_of_manufacture" do
      context "when valid params" do
        it { expect(Post.includes(:car).by_year_of_manufacture(year_of_manufacture_1.id).size).to eq(1) }
      end

      context "when nil params" do
        it { expect(Post.includes(:car).by_year_of_manufacture(nil).size).to eq(Post.all.size) }
      end
    end

    describe ".by_origin" do
      context "when valid params" do
        it { expect(Post.includes(:car).by_origin(origin_1.id).size).to eq(1) }
      end

      context "when nil params" do
        it { expect(Post.includes(:car).by_origin(nil).size).to eq(Post.all.size) }
      end
    end

    describe ".by_gearbox" do
      context "when valid params" do
        it { expect(Post.includes(:car).by_gearbox(gearbox_1.id).size).to eq(1) }
      end

      context "when nil params" do
        it { expect(Post.includes(:car).by_gearbox(nil).size).to eq(Post.all.size) }
      end
    end

    describe ".by_car_type" do
      context "when valid params" do
        it { expect(Post.includes(:car).by_car_type(car_type_1.id).size).to eq(1) }
      end

      context "when nil params" do
        it { expect(Post.includes(:car).by_car_type(nil).size).to eq(Post.all.size) }
      end
    end

    describe ".by_brand" do
      context "when valid params" do
        it { expect(Post.includes(:car).by_brand(brand_1.id).size).to eq(1) }
      end

      context "when nil params" do
        it { expect(Post.includes(:car).by_brand(nil).size).to eq(Post.all.size) }
      end
    end

    describe ".by_car_model" do
      context "when valid params" do
        it { expect(Post.includes(:car).by_car_model(car_model_1.id).size).to eq(1) }
      end

      context "when nil params" do
        it { expect(Post.includes(:car).by_car_model(nil).size).to eq(Post.all.size) }
      end
    end

    describe ".by_created_at" do
      it { expect(Post.by_created_at).to eq(Post.order(created_at: :desc)) }
    end

    describe ".by_updated_at" do
      it { expect(Post.by_updated_at).to eq(Post.order updated_at: :desc) }
    end

    describe ".by_favorite_count" do
      it { expect(Post.by_favorite_count).to eq(Post.left_joins(:favorite_lists).group(:id).order("COUNT(posts.id) DESC")) }
    end

    describe ".this_month" do
      it { expect(Post.by_updated_at).to eq(Post.order updated_at: :desc) }
    end

    describe ".order_by_car_price" do
      context "when param is asc" do
        it { expect(Post.order_by_car_price("asc")).to eq(Post.left_joins(:car).order("price asc")) }
      end

      context "when param is desc" do
        it { expect(Post.order_by_car_price("desc")).to eq(Post.left_joins(:car).order("price desc")) }
      end
    end

    describe "Delegates" do
      it { is_expected.to delegate_method(:name).to(:user).with_prefix(true) }
    end
  end
end
