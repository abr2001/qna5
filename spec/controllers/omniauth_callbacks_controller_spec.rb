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

   context 'with existing facebook user' do
     before do
      auth = mock_auth_hash(:facebook)
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      get :facebook
     end
     it 'redeirects to rootpath' do
        expect(response).to redirect_to(root_path)
     end
     it 'signin user' do
       expect(controller.current_user).to eq user
     end
   end
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

   context 'with existing twitter user' do
     before do
      auth = mock_auth_hash(:twitter)
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      get :twitter
     end
     it 'redeirects to rootpath' do
        expect(response).to redirect_to(root_path)
     end
     it 'signin user' do
       expect(controller.current_user).to eq user
     end
   end
  end
end
