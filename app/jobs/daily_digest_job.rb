class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    User.find_each.each do |user|
      DailyMailer.digest(user).deliver_now
    end
  end
end
