class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :awards
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def author_of?(resource)
    resource.author_id == self.id
  end       
end
