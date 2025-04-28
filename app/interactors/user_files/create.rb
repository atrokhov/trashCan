# frozen_string_literal: true

module UserFiles
  class Create
    include Interactor

    delegate :params, to: :context

    def call
      context.fail!(error: "File is missing") unless params[:file]
      context.fail!(error: "Folder is missing") unless params[:folder]
      context.fail!(error: "User is missing") unless params[:user]

      context.user_file = UserFile.create(**create_params)
      context.fail!(error: context.user_file.errors.full_messages) unless context.user_file.persisted?
    end

    private

    def create_params
      {
        folder: context.params[:folder],
        user: context.params[:user],
        read_only: context.params[:read_only] || false,
        visible: context.params[:visible] || true,
        file: context.params[:file][:tempfile],
        file_type: file_type,
        file_name: file_name,
        file_size: file_size,
        file_extension: file_extension,
        file_mime_type: file_mime_type
      }
    end

    def file_name
      params[:file][:tempfile].original_filename.split(".").first
    end

    def file_extension
      params[:file][:tempfile].original_filename.split(".").last
    end

    def file_mime_type
      content_type = params[:file][:head].partition("Content-Type: ").last.strip
      Rack::Mime.mime_type(File.extname(params[:file][:tempfile].original_filename), fallback = nil) || content_type
    end

    def file_size
      params[:file][:tempfile].size
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
  end
end
