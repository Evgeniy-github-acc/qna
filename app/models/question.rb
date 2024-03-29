class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
end
