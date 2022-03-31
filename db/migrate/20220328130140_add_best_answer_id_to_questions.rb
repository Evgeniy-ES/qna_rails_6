class AddBestAnswerIdToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :best_answer, null: true
  end
end
