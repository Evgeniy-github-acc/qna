module Votable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, as: :votable, dependent: :destroy

    def voting(value:, user:)
      vote = votes.find_or_initialize_by(user: user)

      return if vote.value == value.to_i
      
      vote.value += value.to_i
      vote.save
    end
    
    def rating
      votes.sum(:value)
    end
  end
end 
