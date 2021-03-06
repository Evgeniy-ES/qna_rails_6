require 'rails_helper'

feature 'Author can delete his answer', %q{

} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }
  given(:gist_url) { 'https://gist.github.com/Evgeniy-ES/2abda33eab54d47148358917d84fdb2e' }


  describe 'Authenticated user' do

    scenario 'Author can delete link in his answer', js: true do
      sign_in(author)
      visit question_path(question)

      fill_in 'Your answer', with: 'New answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add answer'
      visit question_path(question)

      click_on 'Delete link'

      save_and_open_page
      expect(page).to_not have_link 'My gist', href: gist_url

    end

    scenario 'Author can delete his question', js: true do
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

    scenario 'author answer can delete file', js: true do
      sign_in(author)
      visit question_path(question)
      fill_in 'Your answer', with: 'Your answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Add answer'

      expect(page).to have_link 'rails_helper.rb'
      click_on 'Delete this file'
      visit question_path(question)
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'Any user can not delete random file', js: true do
      sign_in(author)
      visit question_path(question)
      fill_in 'Your answer', with: 'Your answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Add answer'

      expect(page).to have_link 'rails_helper.rb'
      click_on 'Logout'

      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content 'Delete this file'
    end

  end

  describe 'Unauthenticated user' do
    scenario 'can not delete the answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete the answer'
    end
  end

end
