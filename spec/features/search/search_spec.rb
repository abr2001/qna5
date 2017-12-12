require 'features/features_helper'
require 'features/sphinx_helper'

feature 'Search ', %q{
User can search
} do

  given!(:user) { create(:user, email: "search@email.com") }
  given(:search_string) { 'search' }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, title: search_string) }
  given!(:answer) { create(:answer, body: search_string) }
  given!(:comment) { create(:comment, user: other_user, commentable: question, body: search_string) }

  before { ThinkingSphinx::Test.index }

  Search::SEARCH_OBJECTS.each do |object|
    scenario "User can search in #{object}", js: true do
      ThinkingSphinx::Test.run do
        visit root_path
        expect(page).to have_button 'Search'
        fill_in 'search_string', with: search_string
        select(object, from: 'search_object')
        click_on 'Search'
        save_and_open_page
        expect(page).to have_content object.singularize
      end
    end
  end

  scenario 'User can search everywhere', js: true do
    visit root_path
    expect(page).to have_button 'Search'
    fill_in 'search_string', with: search_string
    click_on 'Search'
    save_and_open_page
    expect(page).to have_content 'Question'
    expect(page).to have_content 'Answer'
    expect(page).to have_content 'Comment'
    expect(page).to have_content 'User'
    expect(page).to have_content '4 objects found'
  end
end
