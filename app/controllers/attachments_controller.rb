class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
    else
      head :forbidden
    end
  end
end
