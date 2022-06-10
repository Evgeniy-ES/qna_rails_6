class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[ index show ]
  before_action :load_question, only: %i[ show edit destroy update ]
  after_action :publish_question, only: [:create]
  before_action :find_subsription, only: [:show, :edit]

  authorize_resource

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
    @question.build_reward
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
    authorize! :destroy, @question
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
                                      links_attributes: [:name, :url],
                                    reward_attributes: [:name, :image])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def find_subsription
   @subscription = question.subscriptions.find_by(user: current_user)
 end
end
