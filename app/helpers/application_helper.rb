module ApplicationHelper
  def show_action?(item)
    user_signed_in? && current_user.author_of?(item)
  end

end
