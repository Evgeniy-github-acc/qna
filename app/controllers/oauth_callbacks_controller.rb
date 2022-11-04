class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    provide_auth("Github")
  end

  def facebook
    provide_auth("Facebook")  
  end

  def vkontakte
    provide_auth("Vk")
  end
  

  private

  def provide_auth(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session['oauth.uid'] = request.env['omniauth.auth'].uid.to_s
      session['oauth.provider'] = request.env['omniauth.auth'].provider
      redirect_to new_user_registration_url
    end
  end
end