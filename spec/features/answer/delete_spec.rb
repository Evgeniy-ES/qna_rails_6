require 'rails_helper'

feature 'Author can delete his answer', %q{

} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  describe 'Authenticated user' do
    scenario 'Author can delete his question' do
      sign_in(author)
      visit question_path(question)
      expect(page).to have_content 'My answer'
      click_on 'Delete the answer'
      expect(page).to_not have_content 'My answer'
    end

    scenario 'Any user can not delete random question' do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_content 'Delete the answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated user can not delete the question' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete the answer'
    end
  end

end