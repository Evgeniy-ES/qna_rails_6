require 'rails_helper'

feature 'User can create answer', %q{
  To give an answer to the question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add a answer', js: true do
      fill_in 'Your answer', with: 'New answer'
      click_on 'Add answer'
      expect(page).to have_content 'New answer'
    end

    scenario 'add a answer with errors ', js: true do
      click_on 'Add answer'
      expect(page).to have_content "Text can't be blank"
    end
  end

  scenario 'Unauthenticated user' do
      visit question_path(question)
      expect(page).to_not have_content "Add answer"      
    end

end
