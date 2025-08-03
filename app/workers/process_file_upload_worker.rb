# frozen_string_literal: true

class ProcessFileUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :uploads

  def perform(signed_id, folder_id, name, room, user_id)
    @result = UserFiles::Create.call(params: file_params(signed_id, folder_id, user_id))

    if @result.success?
      file = @result.user_file
      file_data = file.attributes.slice("id", "created_at", "file_type", "read_only", "visible")
      file_data["name"] = "#{file.file_name}#{'.' + file.file_extension if file.file_extension.present?}"
      file_data["type"] = file.file_type
      file_data["mime_type"] = file.file_mime_type

      ActionCable.server.broadcast(
        "upload_progress_#{room}",
        {
          type: "file_processed",
          file_id: file.id,
          html: render_file(file_data)
        }
      )
    else
      ActionCable.server.broadcast(
        "upload_progress_#{room}",
        {
          type: "error",
          message: "Ошибка при сохранении файла: #{@result.error}"
        }
      )
    end
  end

  private

  def file_params(signed_id, folder_id, user_id)
    {
      file: ActiveStorage::Blob.find_signed(signed_id),
      folder_id: folder_id,
      user_id: user_id
    }
  end

  def render_file(file)
    ApplicationController.render(
      partial: "shared/item",
      locals: { item: file }
    )
  end
end
