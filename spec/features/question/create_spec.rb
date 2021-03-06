require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able ask the question
} do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 3, author: user) }


  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'ask a question reward' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within '.reward' do
        fill_in 'Reward name', with: 'My reward'
        attach_file 'Image', "#{Rails.root}/app/assets/images/reward.png"
      end
      click_on 'Ask'
      expect(Question.last.reward).to eq Reward.last
    end

    scenario 'ask a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'ask a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

  end


  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'List questions' do
    questions

    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
