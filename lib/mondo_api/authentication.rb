module MondoApi
  class Authentication
    MONDO_AUTH_URL = "https://api.getmondo.co.uk/oauth2/token"

    def initialize(http_client:, client_id:, client_secret:)
      @client_id = client_id
      @http_client = http_client
      @client_secret = client_secret
    end

    def get_access_token(authorization_code, redirect_uri)
      response = @http_client.post(MONDO_AUTH_URL,
                                   body: query(authorization_code, redirect_uri),
                                   headers: {"Content-Type" => "application/x-www-form-urlencoded"})

      Response.new(success: response.success?, body: response["access_token"])
    end

    private

    def query(authorization_code, redirect_uri)
      {
        grant_type: "authorization_code",
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uri: redirect_uri,
        code: authorization_code
      }
    end
  end
end
