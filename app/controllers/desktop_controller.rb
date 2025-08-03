class DesktopController < ApplicationController
  before_action :authenticate_user!

  def index
    @folder = current_user.folders.find_by_name("Desktop")
    @files_and_folders = SearchInFolderQuery.new(@folder, params: params).call
    @file = UserFile.new

    respond_to do |format|
      format.html do
        @all_desktops = Folder.where(name: "Desktop").where.not(user: @current_user) if @current_user.admin?
      end
      format.turbo_stream
    end
  end
end
