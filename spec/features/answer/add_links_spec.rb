require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I-d like to be able to add links
  } do
    given(:user) { create(:user) }
    given!(:question) { create(:question, author: user) }
    given(:gist_url) { 'https://gist.github.com/Evgeniy-ES/2abda33eab54d47148358917d84fdb2e' }
    given(:google_url) { 'https://www.google.ru/' }
    given(:invalid_url) { 'invalid.com' }

    describe 'User add' do

      background do
        sign_in(user)
        visit question_path(question)

        fill_in 'Your answer', with: 'New answer'
      end

      scenario ' valid links when asks question', js: true do

         fill_in 'Link name', with: 'My gist'
         fill_in 'Url', with: gist_url

         click_on 'add link'

         within '.nested-fields' do
         fill_in 'Link name', with: 'Google'
         fill_in 'Url', with: google_url
        end

        click_on 'Add answer'

        within '.answers' do
          expect(page).to have_link 'My gist', href: gist_url
          expect(page).to have_link 'Google', href: google_url
        end
      end

      scenario 'invalid links when asks answer', js: true do

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: invalid_url

        click_on 'Add answer'

        expect(page).to_not have_link 'My gist', href: invalid_url
        expect(page).to have_content 'is not a valid URL'
      end
    end
end
