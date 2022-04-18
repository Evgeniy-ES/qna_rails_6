require 'rails_helper'

feature 'The user votes for the answer', %q{
  The user can give and take his vote from the question
} do

  given(:author_question) { create(:user) }
  given(:author_answer) { create(:user) }
  given(:question) { create(:question, author: author_question) }
  given!(:answer) { create(:answer, question: question, author: author_answer) }


  describe 'An authorized user who is not the author of the answer can vote for him ' do
    background do
      sign_in(author_question)
      visit question_path(question)

    end

    scenario 'The user votes +', js: true do
      within '.answers' do
        expect(page).to have_content 'Rating: 0'
        click_on '+'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'The user votes -', js: true do
      within '.answers' do
        expect(page).to have_content 'Rating: 0'
        click_on '-'

        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'The user cancels his vote', js: true do
      within '.answers' do
        expect(page).to have_content 'Rating: 0'
        click_on '+'

        expect(page).to have_content 'Rating: 1'
        click_on 'Cancel voting'

        expect(page).to have_content 'Rating: 0'
      end
    end

  end

  describe 'An authorized user who is not the author of the answer cannot vote for him ' do

    scenario 'there is no possibility to vote', js: true do

      sign_in(author_answer)
      visit question_path(question)

      fill_in 'Your answer', with: 'New answer'
      click_on 'Add answer'

      within '.answers' do
        expect(page).to_not have_content 'Cancel voting'
      end

    end

    describe 'Unauthorized user  ' do

      scenario 'cannot vote', js: true do

        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_content 'Cancel voting'
        end
      end
    end

  end


end
