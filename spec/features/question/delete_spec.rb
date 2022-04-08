require 'rails_helper'

feature 'Author can delete his question', %q{

} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given(:gist_url) { 'https://gist.github.com/Evgeniy-ES/2abda33eab54d47148358917d84fdb2e' }
  given(:question_with_link) { create(:question, :with_link, author: author) }

  describe 'Authenticated user' do
    scenario 'Author can delete his question' do
      sign_in(author)
      visit question_path(question)

      click_on 'Delete the question'

      visit questions_path
      expect(page).to_not have_content question.title
    end

    scenario 'Author can delete link in his question', js: true do
      sign_in(author)
      visit question_path(question_with_link)

      click_on 'Delete link'

      expect(page).to_not have_link 'My gist', href: gist_url

    end

    scenario 'Any user can not delete random question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content 'Delete the question'
    end

    scenario 'author question can delete file' do
      sign_in(author)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'

      click_on 'Delete this file'
      visit question_path(question)
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'Any user can not delete random file', js: true do
      sign_in(author)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      click_on 'Logout'

      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content 'Delete this file'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated user can not delete the question' do
      visit question_path(question)

      expect(page).to_not have_content 'Delete the question'
    end
  end

end
