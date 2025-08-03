class FilesController < ApplicationController
  before_action :set_file, only: [ :show, :destroy ]

  def create
    @result = UserFiles::Create.call(params: file_params)

    if @result.success?
      flash[:notice] = "File uploaded successfully."
      @file = @result.user_file
      @file_data = @file.attributes.slice("id", "created_at", "file_type", "read_only", "visible")
      @file_data["name"] = @file.file_name + "." + @file.file_extension
      @file_data["type"] = @file.file_type
      @file_data["mime_type"] = @file.file_mime_type
    else
      flash[:alert] = @result.errors.full_messages.join(", ")
      @file = UserFile.new
      @file_data = {}
    end
  end

  def destroy
    @file.destroy
  end

  def show
    send_data @file.file.download,
              filename: @file.file.filename.to_s,
              type: @file.file.content_type,
              disposition: :inline
  end

  private

  def set_file
    @file = UserFile.find(params[:id])
  end

  def file_params
    params.require(:user_file).permit(:file, :folder_id, :user_id)
  end
end

