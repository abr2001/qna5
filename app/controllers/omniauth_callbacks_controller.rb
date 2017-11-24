class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_provider
  def facebook
  end

  def twitter
  end

  def register
    session[:auth] = nil
  end

  private
  def sign_in_provider
    if auth.empty?
      redirect_to questions_path
    else
      @user = User.find_for_oauth(auth)
      if @user && @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
      else
        session[:auth] = { uid: auth.uid, provider: auth.provider }
        render 'omniauth_callbacks/enter_email', locals: { auth: auth}
      end
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params_auth)
  end

  def params_auth
    session[:auth] ? params[:auth].merge(session[:auth]) : params[:auth]
  end

end
