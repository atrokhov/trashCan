class FileUploadsController < ApplicationController
  def create
    room = SecureRandom.uuid

    Array(params[:files]).each do |file|
      blob = ActiveStorage::Blob.create_and_upload!(
        io: file,
        filename: file.original_filename,
        content_type: file.content_type
      )

      ProcessFileUploadWorker.new.perform(
        blob.signed_id,
        params[:folder_id],
        params[:name].presence || file.original_filename,
        room,
        current_user.id
      )
    end

    render json: { room: room }, status: :accepted
  end
end
