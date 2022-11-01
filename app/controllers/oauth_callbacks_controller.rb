class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    render json: request.env['omniauth.auth']    
  end

  def facebook
    render json: request.env['omniauth.auth']    
  end
  
end