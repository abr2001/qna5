require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"
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
    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
  it_behaves_like "API Authenticable"
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
    def do_request(options = {})
      get '/api/v1/questions/1', params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"
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
    def do_request(options = {})
      post '/api/v1/questions/', params: { action: :create, format: :json, question: attributes_for(:question)}.merge(options)
    end
  end
end
