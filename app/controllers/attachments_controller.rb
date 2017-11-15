class AttachmentsController < ApplicationController
  before_action :load_attachment, only: [:destroy]

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
    head :forbidden unless current_user.author_of?(@attachment.attachable)
  end
end
