require 'features/features_helper'

feature 'Delete file for question', %q{
  In order to delete file for question
  As an question's author
  I'd like to delete attach files
  } do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question)}

  before {
    login_user
    visit question_path(question)
  }

  scenario 'User sees file for question', js:true do
    expect(page).to have_link attachment.file.filename, href: attachment.file.url
  end

  scenario 'User as athor delete file for question', js:true do
    within('.delete_question_file') do
      click_on 'Delete'
    end
    expect(page).to_not have_link attachment.file.filename, href: attachment.file.url
  end

  let!(:question2) { create(:question) }
  let!(:attachment2) { create(:attachment, attachable: question2)}

  scenario 'User as not athor try delete file for question, but not sees link delete', js:true do
    visit question_path(question2)
    within('.attachment') do
      expect(page).to_not have_link 'Delete'
    end
  end

end
