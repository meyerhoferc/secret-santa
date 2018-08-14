require 'rails_helper'

describe 'welcome page' do
  it 'has information about secret santa' do
    visit '/'

    within('h1') do
      expect(page).to have_content 'Welcome to Secret Santa'
    end
  end
end
