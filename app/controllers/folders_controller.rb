class FoldersController < ApplicationController
  before_action :authenticate_user!
  def show
    @folder = current_user.folders.find(params[:id]) unless current_user.admin?
    @folder ||= Folder.find(params[:id]) if current_user.admin?
    @files_and_folders = SearchInFolderQuery.new(@folder, params: params).call
    @file = UserFile.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
