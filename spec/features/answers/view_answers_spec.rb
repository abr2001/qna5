require 'rails_helper'

feature 'view answers for question', %q{
  In order to get answers for question
  I want view  answers for question
} do

  let!(:question) { create(:question) }
  let!(:answer) { Answer.create(body: 'my answer for question', question: question) }

  scenario 'User view the answers' do
    visit question_path(question.id)
    expect(page).to have_content 'my answer for question'
  end
end
