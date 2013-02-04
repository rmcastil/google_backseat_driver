class GoogleAuthenticator

  def initialize(client=Google::APIClient.new)
    @authorization = client.authorization
    @authorization.client_id = CLIENT_ID
    @authorization.client_secret = CLIENT_SECRET
    @authorization.scope = OAUTH_SCOPE
    @authorization.redirect_uri = REDIRECT_URI
  end

  def get_refresh_token
    authenticate!
    @authorization.refresh_token
  end

  def get_uri
    @authorization.authorization_uri
  end

  def authorization_code=(authorization_code)
    @authorization.code = authorization_code
  end

  def authenticate_with_refresh_token!(token)
    @authorization.refresh_token = token
    authenticate!
  end

  private

  def authenticate!
    @authorization.fetch_access_token!
  end
end
