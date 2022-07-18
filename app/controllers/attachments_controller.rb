class AttachmentsController < ApplicationController
  def purge_file
    @file = ActiveStorage::Attachment.find(params[:attachment_id])
    @file.purge
  end
end
