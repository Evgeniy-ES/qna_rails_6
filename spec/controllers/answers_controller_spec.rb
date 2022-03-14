require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  before { sign_in(user) }

  describe 'GET #show ' do

    before { get :show, params: { question_id: question, id: answer } }

    it 'assign the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { question_id: question, id: answer } }

    it 'assign the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assign a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in database' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end
      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to question
      end
    end

  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assign the requested answer to @answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { text: "New MyText", correct: true } }
        answer.reload

        expect(answer.text).to eq 'New MyText'
        expect(answer.correct).to eq true
      end

      it 'redirects to updated answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }
      it 'does not change answer' do
        answer.reload

        expect(answer.text).to eq 'My answer'
      end
      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user_id: user.id) }

    context 'The author deletes his answer' do
      before { login(user) }
      it 'deletes the answer' do
        expect{ delete :destroy, params: { question_id: question, id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to answer' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'The user deletes not his answer' do
      let(:not_author) { create(:user) }
      before { login(not_author) }

      it 'deletes the answer' do
        expect{ delete :destroy, params: { question_id: question, id: answer } }.to_not change(question.answers, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question
      end
    end



  end


end