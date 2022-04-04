
require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(author)
      visit question_path(question)

      click_on('Edit the question')

      within '.question' do
        fill_in('Your title question', with: 'Edited question title')
        fill_in('Your body question', with: 'Edited question body')
        click_on('Save')

        expect(page).to_not(have_content(question.title))
        expect(page).to_not(have_content(question.body))
        expect(page).to(have_content('Edited question title'))
        expect(page).to(have_content('Edited question body'))
        expect(page).to_not(have_selector('textarea'))
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in(user_author)
      visit question_path(question)

      click_on('Edit the question')

      within '.question' do
        fill_in('Your title question', with: '')
        fill_in('Your body question', with: '')
        click_on('Save')

        expect(page).to(have_content("Title can't be blank"))
        expect(page).to(have_content("Body can't be blank"))
        expect(page).to(have_selector('textarea'))
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not(have_link( 'Edit the question' ))
    end

    scenario 'delete file in a answer', js: true do
      fill_in 'Your answer', with: 'Your answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

  end

  describe 'Unauthenticated user' do
    scenario 'can not edit question' do
      visit question_path(question)
      expect(page).to_not(have_link( 'Edit the question' ))
    end
  end

end
