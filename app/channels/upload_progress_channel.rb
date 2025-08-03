class UploadProgressChannel < ApplicationCable::Channel
  def subscribed
    stream_from "upload_progress_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
