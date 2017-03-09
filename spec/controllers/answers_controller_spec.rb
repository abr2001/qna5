require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  login_user
  let(:question) { create(:question) }

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
    let!(:answer) { create(:answer, user: @user, question: question) }
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

    let!(:answer2) { create(:answer, :with_user, question: question) }
    it "not author can't update answer" do
        post :update, format: :js, params: { id: answer2, answer: { body: 'edited answer' }, question_id: question  }
        answer.reload
        expect(answer.body).to_not eq 'edited answer'
    end
  end

  describe 'DELETE #destroy' do
    context 'author delete answer' do
      let!(:answer) { create(:answer, user: @user, question: question) }
      it 'delete answer in database' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author delete answer' do
      let!(:answer2) { create(:answer, :with_user, question: question) }
      it 'can not delete answer in database' do
        expect { delete :destroy, params: { id: answer2, question_id: question } }.to_not change(Answer, :count)
      end

      it 'redirect to question show' do
        delete :destroy, params: { id: answer2, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

end
