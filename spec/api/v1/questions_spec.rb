require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: {format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token }}

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(2) }

      %w(id title body created_at updated_at).each do |attr|
        it { expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}") }
      end
    end
  end
  describe 'GET /show' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: {format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question)}
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:comment) { create(:comment, commentable: question, user: question.user) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }}

      it { expect(response).to be_success }
      %w(id title body created_at updated_at user).each do |attr|
        it { expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}") }
      end

      context 'attachments' do
        it { expect(response.body).to have_json_size(1).at_path("attachments") }
        it { expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url") }
      end

      context 'comments' do
        it { expect(response.body).to have_json_size(1).at_path("comments") }
        %w(id body).each do |attr|
          it { expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}") }
        end
      end
    end
  end
  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: {format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before{ post '/api/v1/questions/', params: { action: :create, format: :json, access_token: access_token.token,
                                                   question: attributes_for(:question)}}
      it { expect(response).to be_success }
      it {
        expect{ post '/api/v1/questions/', params: { action: :create, format: :json, access_token: access_token.token,
                                                   question: attributes_for(:question)}}.to change(Question, :count).by(1)
      }
    end
  end
end
