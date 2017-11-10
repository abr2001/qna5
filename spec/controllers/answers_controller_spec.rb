require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  login_user
  let!(:question) { create(:question, user: @user) }
  let!(:answer) { create(:answer, user: @user, question: question) }
  let!(:answer2) { create(:answer, :with_user, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, format: :js, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end
      it 'the answer belongs to user' do
        post :create, format: :js, params: { answer: attributes_for(:answer), question_id: question }
        expect(Answer.last.user).to eq(@user)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, format: :js, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'update the new answer in the database' do
        post :update, format: :js, params: { id: answer, answer: { body: 'edited answer' }, question_id: question  }
        answer.reload
        expect(answer.body).to eq 'edited answer'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        post :update, format: :js, params: { id: answer, answer: { body: '' }, question_id: question  }
        answer.reload
        expect(answer.body).to_not eq ''
      end
    end

    it "not author can't update answer" do
        post :update, format: :js, params: { id: answer2, answer: { body: 'edited answer' }, question_id: question  }
        answer.reload
        expect(answer.body).to_not eq 'edited answer'
        expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE #destroy' do
    context 'author delete answer' do
      it 'delete answer in database' do
        expect { delete :destroy, format: :js, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'render js' do
        delete :destroy, format: :js, params: { id: answer, question_id: question }
        expect(response.status).to eq 200
      end
    end

    context 'not author delete answer' do
      it 'can not delete answer in database' do
        expect { delete :destroy, format: :js, params: { id: answer2, question_id: question } }.to_not change(Answer, :count)
      end

      it 'render js' do
        delete :destroy, format: :js, params: { id: answer2, question_id: question }
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #set_best' do
    context 'Question author selects a best answer' do
      it 'change answer in database' do
        get :set_best, format: :js, params: { answer_id: answer, question_id: question  }, xhr: true
        answer.reload
        expect(answer.best).to eq true
      end
      it 'render js' do
        get :set_best, format: :js, params: { answer_id: answer, question_id: question  }, xhr: true
        expect(response.status).to eq 200
      end
    end
    let!(:user2) { create(:user) }
    let!(:question2) { create(:question, user: user2) }
    let!(:answer_22) { create(:answer, :with_user, question: question2) }
    context 'Not Question author not selects a best answer' do
      it 'not change answer in database' do
        get :set_best, format: :js, params: { answer_id: answer_22, question_id: question2  }, xhr: true
        answer_22.reload
        expect(answer_22.best).to eq false
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #comment' do
    let!(:comment_body) { 'test comment' }
    before { post :comment, format: :js, params: { id: answer, body: comment_body } }
    it { expect(answer.comments.count).to eq 1 }
    it { expect(answer.comments.last.body).to eq comment_body }
    it { expect(response).to have_http_status(:ok) }
    it { expect(response.body).to include comment_body }
  end
end
