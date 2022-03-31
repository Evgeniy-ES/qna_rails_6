require 'rails_helper'

feature 'Authenticate user', %q{
  User can login, logout and registration
} do
  given(:user) { create(:user) }

  scenario 'Login user' do
    sign_in(user)
    visit questions_path

    save_and_open_page

    expect(page).to have_content "Welcome, #{user.email}"
  end

  scenario 'Logout user' do
    sign_in(user)
    click_on 'Logout'
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User can register' do
    visit questions_path

    click_on 'registration'

    fill_in 'Email', with: 'test01@test.ru'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Login user with errors' do
    visit root_path
    click_on 'sign in'

    fill_in 'Email', with: nil
    fill_in 'Password', with: nil
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

end
