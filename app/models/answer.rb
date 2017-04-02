class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :rates, as: :ratable, dependent: :destroy

  validates :body, :user, presence: true
  validate :best_only_one

  accepts_nested_attributes_for :attachments, reject_if: :all_blank


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
