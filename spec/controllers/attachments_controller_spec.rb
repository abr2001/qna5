require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  login_user
  let(:question) { create(:question, user: @user) }
  let!(:attachment) { create(:attachment, attachable: question)}

  describe 'DELETE #destroy' do
    before { attachment }
    context 'autor delete attachment' do
      it 'delete attachment in the database' do
        expect { delete :destroy, format: :js, params: { id: attachment } }.to change(Attachment, :count).by(-1)
      end
    end

    context 'not autor delete attachment' do
      let!(:question2) { create(:question) }
      let!(:attachment2) { create(:attachment, attachable: question2)}
      before { attachment2 }
      it 'delete question in the database' do
        expect { delete :destroy, format: :js, params: { id: attachment2 } }.to_not change(Attachment, :count)
      end
      it 'response with status forbidden' do
        delete :destroy, format: :js, params: { id: attachment2 }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

end
