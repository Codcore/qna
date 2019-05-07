require 'active_support/concern'

module AttachableResource
  include ActiveSupport::Concern

  def delete_attachment(resource)
    if params[:purge_attachment_id]
      file = resource.files.find_by_id(params[:purge_attachment_id])
      file.purge
      render 'shared/_delete_attachment.js.erb', locals: { file_id: file.id }
    end
  end
end