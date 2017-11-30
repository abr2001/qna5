class Answer < ApplicationRecord
  include HasAttachments
  include HasRates
  include HasUser
  include HasComments

  belongs_to :question

  validates :body, presence: true
  validate :best_only_one

  after_commit :notify_subscribers, on: :create

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

  def notify_subscribers
    NewAnswerJob.perform_later(self)
  end

end
