require 'features/features_helper'

feature 'Add file to answers', %q{
  In order to illustrate my answers
  As an question's author
  I'd like to be able to attach files
  } do

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before {
    login_user
    visit question_path(question)
  }

  scenario 'User adds file when do answer' do
    fill_in 'Answer', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
