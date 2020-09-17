class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    check_auth_user Settings.facebook
  end

  def google_oauth2
    check_auth_user Settings.google
  end

  def failure
    redirect_to login_path
  end

  private

  def check_auth_user kind
    @user = User.from_omniauth request.env["omniauth.auth"]
    if @user.persisted?
      sign_out_all_scopes
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: kind)
      end
    else
      flash[:alert] = t "devise.omniauth_callbacks.failure", kind: kind,
        reason: "#{auth.info.email} is not authorized."
      redirect_to signup_path
    end
  end
end
