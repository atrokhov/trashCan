class SearchInFolderQuery
  def initialize(folder, params: {})
    @folder = folder
    @params = params
  end

  def self.call(folder, params: {})
    raise ArgumentError, "Folder cannot be nil" if folder.nil?

    params = {} unless params.is_a?(Hash)

    new(folder, params: params).call
  end

  def call
    {
      total_count:,
      total_pages:,
      items: ActiveRecord::Base.connection.select_all(query).to_a
    }
  end

  private

  def folders
    folders = Folder.where(folder_id: @folder.id)
    folders = folders.where("name ILIKE ?", "%#{@params[:search][:query].strip}%") if @params[:search] && @params[:search][:query].present?

    folders
  end

  def files
    files = UserFile.where(folder_id: @folder.id)
    files = files.where("file_name ILIKE ?", "%#{@params[:search][:query].strip}%") if @params[:search] && @params[:search][:query].present?

    files
  end

  def folders_sql
    folders.select("id, visible, read_only, name, created_at, 'folder' AS type, 'folder' AS mime_type").to_sql
  end

  def files_sql
    types_case = <<~SQL
      CASE file_type
        #{UserFile.file_types.map do |type, index|
          "WHEN #{index} THEN '#{type}'"
        end.join(' ')}
      END AS type
    SQL

    files.select(
      "id, visible, read_only, file_name || COALESCE('.' || NULLIF(file_extension, ''), '') AS name, created_at, #{types_case}, file_mime_type AS mime_type"
    ).to_sql
  end

  def sort_field
    @folder.settings[:sort_field] || "created_at"
  end

  def sort_direction
    @folder.settings[:sort_direction] || "DESC"
  end

  def offset
    return @params[:page].to_i - 1 if @params[:page]

    0
  end

  def limit
    @params[:per_page] || 60
  end

  def total_count
    folders.count + files.count
  end

  def total_pages
    (total_count / limit.to_f).ceil
  end

  def query
    <<~SQL
      #{folders_sql}
      UNION
      #{files_sql}
      ORDER BY #{sort_field} #{sort_direction}
      OFFSET #{offset * limit}
      LIMIT #{limit}
    SQL
  end
end
