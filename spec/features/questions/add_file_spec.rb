require 'features/features_helper'

feature 'Add file to questions', %q{
  In order to illustrate my questions
  As an question's author
  I'd like to be able to attach files
  } do

  let(:user) { create(:user) }

  before {
    login_user
    visit new_question_path
  }

  scenario 'User adds file when asks question', js:true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    click_on 'Add attachment'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add attachment'
    all('.fields').last.attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Save'
    expect(page).to have_link 'spec_helper.rb', href: Question.last.attachments.first.file.url
    expect(page).to have_link 'rails_helper.rb', href: Question.last.attachments.last.file.url
  end
end
