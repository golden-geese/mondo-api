module MondoApi
  class Accounts
    ACCOUNTS_URL = "https://api.getmondo.co.uk/accounts"

    def initialize(http_client: HTTParty, access_token:)
      @http_client = http_client
      @access_token = access_token
    end

    def list
      response = @http_client.get(ACCOUNTS_URL,
                                  headers: headers)

      Response.new(success: response.success?, body: response.body["accounts"])
    end

    private

    def headers
      {"Authorization" => "Bearer #{@access_token}"}
    end
  end
end
