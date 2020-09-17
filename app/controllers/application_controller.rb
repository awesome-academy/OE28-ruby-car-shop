class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.html do
        redirect_to(request.referer ||
                    root_url, alert: t("global.no_permission"))
      end
      format.js{render nothing: true, status: :not_found}
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::USER_PARAMS)
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.get_error"
    redirect_to root_url
  end

  # rubocop:disable Metrics/AbcSize
  def load_posts
    @posts = Post.by_year_of_manufacture(params[:year_of_manufacture_id])
                 .by_fuel(params[:fuel_id])
                 .by_gearbox(params[:gearbox_id])
                 .by_car_type(params[:car_type_id])
                 .by_origin(params[:origin_id])
                 .by_brand(params[:brand_id])
                 .by_car_model(params[:car_model_id])
                 .by_color(params[:color_id])
                 .by_number_of_seat(params[:number_of_seat_id])
                 .by_condition(params[:condition_id])
                 .include_car
  end
  # rubocop:enable Metrics/AbcSize
end
