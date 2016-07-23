module MondoApi
  class Client
    def initialize(http_client: HTTParty, access_token: nil)
      @http_client = http_client
      @access_token = access_token
    end

    def authenticate(client_id:, client_secret:, authorization_code:, redirect_url:)
      @access_token = authentication(client_id: client_id, client_secret: client_secret).get_access_token(authorization_code, redirect_url)
    end

    def webhooks(account_id: nil)
      Webhooks.new(http_client: @http_client, access_token: @access_token, account_id: account_id)
    end

    def authentication(client_id:, client_secret:)
      Authentication.new(http_client: @http_client, client_id: client_id, client_secret: client_secret)
    end
  end
end
