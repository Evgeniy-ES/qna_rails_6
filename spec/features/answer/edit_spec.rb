require 'rails_helper'

feature 'User can edit answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }
  given(:google_url) { 'https://www.google.ru/' }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his link with answer', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'



      within '.answers' do
        click_on 'add link'
       fill_in 'Link name', with: 'Google'
       fill_in 'Url', with: google_url
      end

      click_on 'Save'

      expect(page).to have_link 'Google', href: google_url


    end

    scenario 'edits his answer', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.text
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content answer.text
      end

      expect(page).to have_content "Text can't be blank"
    end

    scenario 'set answer as best', js: true do
      sign_in(author)
      visit question_path(question)

      click_on('Mark as best')

      expect(page).to have_content("The best answer")
    end

    scenario 'Initially there is no better answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content('Mark as best')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit the answer' do
      visit question_path(question)
      expect(page).to_not have_link('Edit')
    end
  end

end
