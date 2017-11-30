require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: {format: :json, access_token: access_token.token} }

      it { expect(response).to be_success }

      %w(id email created_at updated_at admin).each do |attr|
        it { expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr) }
      end

      %w(password encrypted_password).each do |attr|
        it { expect(response.body).to_not have_json_path(attr) }
      end
    end
    def do_request(options = {})
      get '/api/v1/profiles/me', params: {format: :json}.merge(options)
    end
  end


  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:not_me) { create_list(:user, 2) }

      before { get '/api/v1/profiles/', params: {format: :json, access_token: access_token.token} }

      it { expect(response).to be_success }

      it 'doesnt contain current user' do
        expect(response.body).to be_json_eql(not_me.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it { expect(response.body).to be_json_eql(not_me.first.send(attr.to_sym).to_json).at_path("0/#{attr}") }
      end

      %w(password encrypted_password).each do |attr|
        it { expect(response.body).to_not have_json_path(attr) }
      end
    end
    def do_request(options = {})
      get '/api/v1/profiles/', params: {format: :json}.merge(options)
    end
  end
end
