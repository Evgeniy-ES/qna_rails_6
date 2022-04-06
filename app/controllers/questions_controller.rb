class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :load_question, only: %i[ show edit destroy update ]

  def index
    @questions = Question.all
  end

  def show
    @other_answers = question.answers.where.not(id: question.best_answer)
    @best_answer = @question.best_answer
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end

  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                      links_attributes: [:name, :url])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
