class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, :user, presence: true
  validate :best_only_one

  private

  def best_only_one
    if best != best_was and Answer.where(best: true).where(question_id: question_id).count > 0
      errors.add(:base, 'Must be the best only one answer')
    end
  end
end
