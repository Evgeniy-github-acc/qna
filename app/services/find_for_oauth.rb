class FindForOauth
  attr_reader :provider, :uid, :email
  
  def initialize(auth)  
    @provider = auth.provider
    @uid = auth.uid
    @email = auth.info&.email
  end

  def call
    authorization = Authorization.where(provider: provider, uid: uid.to_s).first
    user = authorization&.user
    return user if user

    if email&.present?
      user = User.find_by(email: email) || create_user
      user.authorizations.create!(provider: provider, uid: uid) unless authorization
    end
    user
  end

  private

  def create_user
    User.create!(email: email, password: Devise.friendly_token[0, 20], confirmed_at: Time.now)
  end
end
