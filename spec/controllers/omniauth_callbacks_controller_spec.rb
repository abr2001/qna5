require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  describe 'facebook' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:facebook)
    end
    context 'with a new facebook user' do
      before do
        get :facebook
      end
      it 'redeirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end
      it 'new facebook user is in the database' do
        email = request.env["omniauth.auth"].info.email
        expect(email).to eq User.first.email
      end
    end

    it_behaves_like 'Existing user', :facebook
  end

  describe 'twitter' do
   before do
     request.env["devise.mapping"] = Devise.mappings[:user]
     request.env["omniauth.auth"] = mock_auth_hash(:twitter)
   end
   context 'with a new twitter user' do
     before do
       get :twitter
     end
     it 'redeirects to new_user_path' do
       expect(response).to render_template 'omniauth_callbacks/enter_email'
     end
     it 'doesnt signin user' do
       expect(controller.current_user).to eq nil
     end
   end

   it_behaves_like 'Existing user', :twitter
  end
end
