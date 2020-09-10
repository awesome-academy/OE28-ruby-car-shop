require "rails_helper"

RSpec.describe PostsController, type: :controller do
  let!(:current_user){FactoryBot.create :user}
  let!(:posts){FactoryBot.create :post, user_id: current_user.id, activated: true}
  let!(:posts_2){FactoryBot.create :post, user_id: current_user.id, activated: false}
  let!(:posts_3){FactoryBot.create :post, user_id: 1, activated: false}
  let!(:params) {FactoryBot.attributes_for :post}

  context "When user does not login" do
    describe "GET #index" do
      before { get :index }
      it { expect(assigns :posts).to eq(Post.by_activated.by_updated_at.slice(0, Settings.page)) }
      it { expect(response).to render_template :index }
    end

    describe "GET #new" do
      before {get :new, params: {locale: "vi"}}
      it { expect(response).to redirect_to new_user_session_path }
    end

    describe "POST #create" do
      context "when params is valid" do
        before {post :create, params: {post: params, locale: "vi"}}
        it { expect(response).to redirect_to new_user_session_path }
      end

      context "when params is invalid" do
        before {post :create, params: {post: {name: ""}, locale: "vi"}}
        it { expect(response).to redirect_to new_user_session_path }
      end
    end

    describe "GET #edit" do
      context "when post_id is invalid" do
        before {get :edit, params: {id: 0, locale: "vi"}}
        it { expect(response).to redirect_to new_user_session_path }
      end

      context "when post_id is valid" do
        before {get :edit, params: {id: posts.id, locale: "vi"}}
        it { expect(response).to redirect_to new_user_session_path }
      end
    end

    describe "PUT #update" do
      context "when post_id is invalid" do
        before {put :update, params: {id: 0, locale: "vi"}}
        it { expect(response).to redirect_to new_user_session_path }
      end

      context "when post_id is valid" do
        before {put :update, params: {id: posts.id, post: params, locale: "vi"}}
        it { expect(response).to redirect_to new_user_session_path }
      end
    end

    describe "DELETE #destroy" do
      context "when post_id is invalid" do
        before {delete :destroy, params: {id: 0, locale: "vi"}}
        it { expect(response).to redirect_to new_user_session_path }
      end

      context "when post_id is valid" do
        before {delete :destroy, params: {id: posts_2.id, locale: "vi"}}
        it { expect(response).to redirect_to new_user_session_path }
      end
    end

    describe "GET #show" do
      before {get :show, params: {id: posts.id, locale: "vi"}}
      it { expect(response).to render_template :show }
    end
  end

  context "When user login" do
    before {log_in current_user}

    describe "GET #index" do
      before { get :index }
      it { expect(assigns :posts).to eq(Post.by_activated.by_updated_at.slice(0, Settings.page)) }
      it { expect(response).to render_template :index }
    end

    describe "GET #show" do
      context "when post is active" do
        before {get :show, params: {id: posts.id}}
        it { expect(response).to render_template :show }
      end

      context "when post is inactive and user is post author" do
        before {get :show, params: {id: posts_2.id}}
        it { expect(response).to render_template :show }
      end

      context "when post is inactive and user is not post author" do
        before {get :show, params: {id: posts_3.id}}
        it { expect(response).to redirect_to car_list_path }
        it { expect(flash[:danger]).to eq I18n.t("posts.not_found_post") }
      end
    end

    describe "GET #new" do
      before {get :new}
      it { expect(response).to render_template :new }
    end

    describe "POST #create" do
      context "when params is valid" do
        before {post :create, params: {post: params}}
        it { expect{Post.create(params)}.to change(Post, :count).by(1) }
        it { expect(flash[:success]).to eq I18n.t("posts.create.create_success") }
      end

      context "when params is invalid" do
        before {post :create, params: {post: {name: ""}}}
        it { expect(response).to render_template :new }
        it { expect(flash.now[:danger]).to eq I18n.t("posts.create.create_failed") }
      end
    end

    describe "GET #edit" do
      context "when post_id is invalid" do
        before {get :edit, params: {id: 0}}
        it { expect(response).to redirect_to car_list_path }
        it { expect(flash[:danger]).to eq I18n.t("posts.not_found_post") }
      end

      context "when post_id is valid" do
        before {get :edit, params: {id: posts.id}}
        it { expect(response).to render_template :edit }
      end
    end

    describe "PUT #update" do
      context "when post_id is invalid" do
        before {put :update, params: {id: 0}}
        it { expect(response).to redirect_to car_list_path }
        it { expect(flash[:danger]).to eq I18n.t("posts.not_found_post") }
      end

      context "when post_id is valid" do
        before {put :update, params: {id: posts.id, post: params}}
        it { expect(response).to redirect_to action: :show, id: posts.id }
        it { expect(flash[:success]).to eq I18n.t("posts.update.update_success") }
      end
    end

    describe "DELETE #destroy" do
      context "when post_id is invalid" do
        before {delete :destroy, params: {id: 0}}
        it { expect{posts}.to change(Post, :count).by(0) }
        it { expect(flash[:danger]).to eq I18n.t("posts.not_found_post") }
      end

      context "when post_id is valid" do
        before {delete :destroy, params: {id: posts_2.id}}
        it { expect{posts.destroy}.to change(Post, :count).by(-1) }
        it { expect(flash[:success]).to eq I18n.t("posts.destroy.delete_success") }
      end
    end
  end
end
