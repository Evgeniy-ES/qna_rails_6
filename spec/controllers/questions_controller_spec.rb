require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:not_author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before  { get :index }
    it 'populates an array of all questions' do
      get :index

      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do

    context 'The author' do
      before { login(user) }
      before { get :edit, params: { id: question } }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end

    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid atributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question), author: user } }.to change(Question, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question), author: user }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid atributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'with valid atributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirects to updated question' do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js }
        expect(response).to redirect_to question
      end

    end

    context 'with invalid atributes' do
      before { patch :update, params: {id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end

    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user_id: user.id) }

    context 'The author deletes his question' do
      before { login(user) }
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'The user deletes not his question' do

      let(:question) { create(:question, user_id: user.id) }
      let(:not_author) { create(:user) }
      before { login(not_author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

    end



  end
end
