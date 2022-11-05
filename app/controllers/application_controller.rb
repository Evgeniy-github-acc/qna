class ApplicationController < ActionController::Base
  
  before_action :current_user_to_gon, if: -> { current_user.present? }

  def current_user_to_gon
    gon.current_user = current_user
  end
end
