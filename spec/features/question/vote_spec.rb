require 'rails_helper'

feature 'The user votes for the answer', %q{
  The user can give and take his vote from the question
} do

  given(:author_question) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: author_question) }


  describe 'An authorized user who is not the author of the question can vote for him ' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'The user votes +', js: true do
      within '.question' do
        expect(page).to have_content 'Rating: 0'
        click_on '+'
        visit question_path(question)
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'The user votes -', js: true do
      within '.question' do
        expect(page).to have_content 'Rating: 0'
        click_on '-'
        visit question_path(question)
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'The user cancels his vote', js: true do
      within '.question' do
        expect(page).to have_content 'Rating: 0'
        click_on '+'
        visit question_path(question)
        expect(page).to have_content 'Rating: 1'
        click_on 'Cancel voting'
        visit question_path(question)
        expect(page).to have_content 'Rating: 0'
      end
    end

  end

  describe 'An authorized user who is not the author of the question cannot vote for him ' do

    scenario 'there is no possibility to vote', js: true do

      sign_in(author_question)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_content 'Cancel voting'
      end

    end

    describe 'Unauthorized user  ' do

      scenario 'cannot vote', js: true do

        visit question_path(question)

        within '.question' do
          expect(page).to_not have_content 'Cancel voting'
        end
      end
    end

  end


end
