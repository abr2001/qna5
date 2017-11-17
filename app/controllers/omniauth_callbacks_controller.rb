class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_provider
  def facebook
  end

  def twitter
  end

  def register
  end

  private
  def sign_in_provider
  end
end
