class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[ new create ]
  before_action :load_answer, only: %i[ show edit update destroy ]

  def show
  end

  def edit
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    #  else
    #   redirect_to @question, notice: "Answer can't be blank."
    end

  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question)
    else
      redirect_to question_path(@answer.question)
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text, :correct)
  end
end
