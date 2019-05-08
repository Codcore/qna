class AttachmentsController < ApplicationController
  include AuthorizeableResource
  expose :attachment, -> { ActiveStorage::Attachment.find_by_id(params[:id]) }

  before_action :authenticate_user!
  before_action -> { authorize_author_for!(attachment.record) }

  def destroy
    attachment.purge
  end
end
