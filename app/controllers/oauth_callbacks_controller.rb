class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    provide_auth("Github")
  end

  def facebook
    provide_auth("Facebook")  
  end

  private

  def provide_auth(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something weent wrong'
    end
  end
end