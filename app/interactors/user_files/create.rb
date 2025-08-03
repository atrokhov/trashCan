# frozen_string_literal: true

module UserFiles
  class Create
    include Interactor

    delegate :params, to: :context

    def call
      context.fail!(error: "File is missing") unless params[:file]
      context.fail!(error: "Folder is missing") unless params[:folder_id]
      context.fail!(error: "User is missing") unless params[:user_id]

      context.user_file = UserFile.new
      context.user_file.file.attach(params[:file])
      context.user_file.assign_attributes(create_params)
      p create_params
      p original_filename
      context.fail!(error: context.user_file.errors.full_messages.join(", ")) unless context.user_file.save
    end

    private

    def create_params
      {
        folder: folder,
        user: user,
        read_only: context.params[:read_only] || false,
        visible: context.params[:visible] || true,
        file_type: file_type,
        file_name: file_name,
        file_size: file_size,
        file_extension: file_extension,
        file_mime_type: file_mime_type
      }
    end

    def original_filename
      if params[:file].is_a?(Hash)
        tempfile.original_filename
      elsif params[:file].respond_to?(:original_filename)
        params[:file].original_filename
      elsif params[:file].respond_to?(:filename)
        params[:file].filename.to_s
      else
        raise ArgumentError, "File must respond to :original_filename or :filename"
      end
    end

    def file_name
      params[:file_name] || original_filename.split(".").first
    end

    def file_extension
      original_filename.include?(".") ? original_filename.split(".").last : ""
    end

    def file_mime_type
      if params[:file].is_a?(Hash)
        header = params[:file][:head]
      elsif params[:file].respond_to?(:headers)
        header = params[:file].headers
      elsif params[:file].respond_to?(:content_type)
        content_type = params[:file].content_type
      end

      content_type = header.partition("Content-Type: ").last.strip if header

      Rack::Mime.mime_type(File.extname(original_filename), fallback = nil) || content_type
    end

    def file_size
      params[:file].is_a?(::ActiveStorage::Blob) ? params[:file].byte_size : tempfile.size
    end

    def folder
      @folder ||= Folder.find(context.params[:folder_id])
    end

    def user
      @user ||= User.find(context.params[:user_id])
    end

    def file_type
      mime_type = file_mime_type

      case mime_type
      when /^image/
        :image
      when /^video/
        :video
      when /^audio/
        :audio
      when /^application/
        :application
      when /^text/
        :text
      when /^font/
        :font
      else
        :another
      end
    end

    def tempfile
      @tempfile ||= params[:file].is_a?(Hash) ? params[:file][:tempfile] : params[:file].tempfile

      @tempfile.open
    end
  end
end
