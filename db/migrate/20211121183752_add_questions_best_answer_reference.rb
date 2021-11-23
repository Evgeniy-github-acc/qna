class AddQuestionsBestAnswerReference < ActiveRecord::Migration[6.1]
  def change
    add_reference(:questions, :best_answer, foreign_key: { to_table: :answers }, optional: true)
  end
end
