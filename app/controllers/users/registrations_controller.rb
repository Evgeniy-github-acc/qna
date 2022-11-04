# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :generate_password, only: :create, if: -> { omni_authed? }
  after_action -> { create_authorization resource }, only: :create, if: -> { omni_authed? && resource&.persisted? }

  def create
    if omni_authed?
      email = params[:user][:email]
      user = User.find_by(email: email)

      if user
        create_authorization(user)
        return redirect_existing_user(user)
      end
    end
    super
  end


  private

  def omni_authed?
    session['oauth.uid'].present? && session['oauth.provider'].present?
  end

  def generate_password
    params[:user][:password] = Devise.friendly_token[0, 20]
  end

  def create_authorization(user)
    user.authorizations.create!(provider: session['oauth.provider'], uid: session['oauth.uid'])
    session.delete('oauth.uid')
    session.delete('oauth.provider')
  end

  def redirect_existing_user(user)
    if user.active_for_authentication?
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, user)
      respond_with user, location: after_sign_up_path_for(user)
    else
      set_flash_message! :notice, :"signed_up_but_#{user.inactive_message}"
      expire_data_after_sign_in!
      respond_with user, location: after_inactive_sign_up_path_for(user)
    end
  end
end
