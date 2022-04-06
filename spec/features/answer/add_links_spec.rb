require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I-d like to be able to add links
  } do
    given(:user) { create(:user) }
    given!(:question) { create(:question, author: user) }
    given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

    scenario 'User adds links when asks answer', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: 'New answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end
end
