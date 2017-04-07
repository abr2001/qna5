class Answer < ApplicationRecord
  include Associations
  belongs_to :question
  belongs_to :user

  validates :body, :user, presence: true
  validate :best_only_one

  def set_best
    Answer.transaction do
      Answer.where(question_id: question).where(best: true).update_all(best: false)
      update_attributes(best: true)
    end
  end

  private

  def best_only_one
    if best != best_was && question.answers.where(best: true).exists?
      errors.add(:base, 'Must be the best only one answer')
    end
  end
end
