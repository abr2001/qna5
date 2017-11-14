require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) {create(:question, user: user)}

  describe 'POST #create' do
    login_user
    it 'saves new comment to database' do
      expect { post :create, params:{ commentable: 'questions',
                                      user_id: user, question_id: question.id,
       comment: attributes_for(:comment), format: :js} }.to change(question.comments, :count).by(1)
    end
    it 'render template create' do
      post :create, params:{ commentable: 'questions',
                             user_id: user, question_id: question.id,
                             comment: attributes_for(:comment), format: :js}
      expect(response).to render_template :create
    end
  end

end



