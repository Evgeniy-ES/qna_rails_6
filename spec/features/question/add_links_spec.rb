require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I-d like to be able to add links
  } do
    given(:user) { create(:user) }
    given(:gist_url) { 'https://gist.github.com/Evgeniy-ES/2abda33eab54d47148358917d84fdb2e' }
    given(:google_url) { 'https://www.google.ru/' }
    given(:invalid_url) { 'invalid.com' }

    describe 'User add' do

      background do
        sign_in(user)
        visit new_question_path



      end

      scenario ' valid link when asks question', js: true do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Ask'

        expect(page).to have_link 'My gist', href: gist_url
      end

      scenario 'some valid links when asks question', js: true do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'add link'

        within '.nested-fields' do
         fill_in 'Link name', with: 'Google'
         fill_in 'Url', with: google_url
        end

        click_on 'Ask'

        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'Google', href: google_url
      end

      scenario 'invalid links when asks question', js: true do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: invalid_url

        click_on 'Ask'

        expect(page).to_not have_link 'My gist', href: invalid_url
        expect(page).to have_content 'is not a valid URL'
      end
    end
end
