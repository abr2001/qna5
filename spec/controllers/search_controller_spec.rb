require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #search' do
    it 'get search everywhere with empty search_object' do
      expect(Search).to receive(:search_result).with('ask', '')
      get :search, params: {search_string: 'ask', search_object: ''}
    end

    it 'get search everywhere with search_object Everywhere' do
      expect(Search).to receive(:search_result).with('ask', 'Everywhere')
      get :search, params: {search_string: 'ask', search_object: 'Everywhere'}
    end


    Search::SEARCH_OBJECTS.each do |object|
      it "gets search_object: #{object}" do
        expect(Search).to receive(:search_result).with('ask', object)
        get :search, params: {search_string: 'ask', search_object: object}
      end
    end

    Search::SEARCH_OBJECTS.each do |object|
      it "redirect to search for: #{object}" do
        get :search, params: {search_string: 'ask', search_object: object}
        expect(response).to render_template :search
      end
    end

    it "gets search_object: noname" do
      expect(Search).to receive(:search_result).with('ask', 'Noname')
      # expect(ThinkingSphinx).to receive(:search).with('ask')
      get :search, params: {search_string: 'ask', search_object: 'Noname'}
    end
  end

end
