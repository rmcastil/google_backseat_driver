class GoogleDriveClient
  def initialize(refresh_token)
    @client = Google::APIClient.new
    authenticator = GoogleAuthenticator.new(@client)
    authenticator.authenticate_with_refresh_token!(refresh_token)

    @drive = @client.discovered_api('drive', 'v2')
  end

  def get_all_files
    result = @client.execute(
                              api_method: @drive.files.list,
                              parameters: {}
    )

    result.data.items
  end

  def find_file(name, path=nil)
    parameter = {}

    if has_splat_extension?(name)
      operator = "contains"
      name = remove_splat_extension(name)
    else
      operator = "="
    end

    if path.blank?
      parameter[:q] = "title #{operator} '#{name}'"
    else
      # this just finds based on the immediate parent. Hank said there was no need
      # to go further down in the ancestry chain
      parameter[:q] = "title #{operator} '#{name}' and '#{find_file(path, nil).id}' in parents"
    end

    result = @client.execute(
                              api_method: @drive.files.list,
                              parameters: parameter
    )

    result.data.items.first
  end

  def create_folder(name)
    # Artists should not be hardcoded in here
    parent = find_file('Artists')

    file = @drive.files.insert.request_schema.new(
      {
        'title' => name,
        'mimeType' => 'application/vnd.google-apps.folder',
      }
    )

    file.parents = [{'id' => parent.id}]

    result = @client.execute(
                              api_method: @drive.files.insert,
                              body_object: file
    )

    if result.status == 200
      return result.data
    end
  end

  def find_or_create_folder(name)
    result = find_file(name)

    if result.blank?
      result = create_folder(name)
    end

    result
  end

  private

  def has_splat_extension?(name)
    name[-1].include?('*')
  end

  def remove_splat_extension(name)
    name[0..-3]
  end
end
