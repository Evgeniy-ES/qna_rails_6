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

    scenario 'asks a answer with attached file', js: true do
      fill_in 'Your answer', with: 'Your answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end    
  end

  scenario 'Unauthenticated user' do
      visit question_path(question)
      expect(page).to_not have_content "Add answer"
    end

end
