class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :awards
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[github facebook vkontakte]

  def author_of?(resource)
    resource.author_id == self.id
  end
  
  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def subscribed?(question)
    subscriptions.where(question_id: question.id).any?
  end
end
