class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscriptions.map{|s| s.user}.each do |user|
      if answer.user != user
        AnswerMailer.notifier(answer, user).deliver_later
      end
    end
  end
end
