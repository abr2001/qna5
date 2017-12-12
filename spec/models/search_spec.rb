require 'rails_helper'

RSpec.describe Search do

  describe 'method search_result' do
    %w(Noname Everywhere '').each do |object|
      it "gets search object #{object}" do
        expect(ThinkingSphinx).to receive(:search).with('search')
        Search.search_result('search', object)
      end
    end

    Search::SEARCH_OBJECTS.each.each do |object|
      it "gets search object: #{object}" do
        expect(object.singularize.constantize).to receive(:search).with('search')
        Search.search_result('search', object)
      end
    end
  end
end
