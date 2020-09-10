class UsersController < ApplicationController
  before_action :load_user, :authenticate_user!, only: %i(show edit update)

  def show
    @posts = current_user.posts.page(params[:page]).per Settings.page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".new.sign_up_success"
      redirect_to @user
    else
      flash[:danger] = t ".new.sign_up_fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end
end
