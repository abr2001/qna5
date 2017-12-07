class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('updated_at > ?', 24.hours.ago)
    mail to: user.email
  end
end
