require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'validations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user }

    let!(:question) { create(:question) }
    let!(:answer)   { create(:answer, :with_user, question: question) }
    let!(:answer_2) { create(:answer, :with_user, question: question) }
    it 'Must be the best only one answer' do
      answer.update_attributes(best: true)
      answer_2.update_attributes(best: true)
      expect(answer.valid?).to eq true
      expect(answer_2.errors.messages[:base]).to include('Must be the best only one answer')
    end

  describe 'methods' do
    it 'Set_best must change attribute best to true in database' do
      answer.set_best
      answer.reload
      expect(answer.best).to eq(true)
      answer_2.set_best
      answer_2.reload
      answer.reload
      expect(answer_2.best).to eq(true)
      expect(answer.best).to eq(false)
    end
  end

  end
end

