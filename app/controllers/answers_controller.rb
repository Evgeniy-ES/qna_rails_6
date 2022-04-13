class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[ new create ]
  before_action :load_answer, only: %i[ show edit update destroy ]


  def edit
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user


    respond_to do |format|
      if @answer.save
        format.html { render @answer }
      else
        format.html do
          render partial: 'shared/errors', locals: { resource: @answer },
                          status: :unprocessable_entity
        end
      end
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
      @other_answers = @question.answers.where.not(id: @question.best_answer)
      @best_answer = @question.best_answer
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @question = @answer.question
      @answer.destroy
    end
  end

  def mark_as_best
   answer = Answer.find(params[:answer_id])
   question = answer.question
   question.update(best_answer_id: answer.id)
   question.set_best_answer(answer)

   @best_answer = answer
   @other_answers = question.answers.where.not(id: question.best_answer)

   render :template => 'answers/mark_as_best.js.erb'
 end


  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:text, :correct, files: [], links_attributes: [:name, :url, :_destroy, :id])
  end
end
