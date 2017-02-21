require 'rails_helper'

feature 'delete answer for question', %q{
  In order to delete answers for question
  Authenticated user
  I want delete  answer for question
} do

  let!(:question) { create(:question) }
  let!(:answer) { Answer.create(body: 'my answer for question', question: question) }

  scenario 'User view the answers' do
    login_user
    visit question_path(question.id)
    click_on 'Delete'
    save_and_open_page

    expect(page).to have_content 'my answer for question'
  end
end
