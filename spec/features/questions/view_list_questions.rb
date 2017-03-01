require 'rails_helper'

feature 'View questions', %q{
  In order to get list questions
  As an any user
  I want view questions
} do

  scenario 'User view the list of questions' do
    create_list(:question, 5, title: 'new question')
    visit questions_path

    expect(page).to have_content 'new question'
  end
end
