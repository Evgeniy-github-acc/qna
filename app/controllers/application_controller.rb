class ApplicationController < ActionController::Base
  
  before_action :current_user_to_gon, if: -> { current_user.present? }

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def current_user_to_gon
    gon.current_user = current_user
  end
end
