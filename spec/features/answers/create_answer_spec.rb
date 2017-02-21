require 'rails_helper'

feature 'Create answer', %q{
  In order to get answer from community
  I want to be able to ask the question
} do

  let(:question) { create(:question) }
  scenario 'User create the answer' do
    login_user
    visit question_path(question.id)

    fill_in 'Answer', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created'
  end
end
