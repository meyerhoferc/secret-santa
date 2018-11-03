require 'rails_helper'

describe 'welcome page' do
  it 'has information about secret santa' do
    visit '/'
    expect(page).to have_link 'Log In'
    expect(page).to have_link 'Sign Up'

    within('h1') do
      expect(page).to have_content 'Welcome to Secret Santa'
    end
  end
end
