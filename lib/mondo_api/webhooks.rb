module MondoApi
  class Webhooks
    WEBHOOK_URL = "https://api.getmondo.co.uk/webhooks"

    def initialize(http_client: HTTParty, access_token:, account_id:)
      @http_client = http_client
      @access_token = access_token
      @account_id = account_id
    end

    def register(callback_url)
      response = @http_client.post(WEBHOOK_URL,
                                   body: body(callback_url),
                                   headers: headers)

      Response.new(success: response.success?, body: response)
    end

    def list
      response = @http_client.get("#{WEBHOOK_URL}?account_id=#{@account_id}",
                                  headers: headers)

      Response.new(success: response.success?, body: response["webhooks"])
    end

    private

    def body(callback_url)
      { account_id: @account_id, url: callback_url }
    end

    def headers
      {"Authorization" => "Bearer #{@access_token}"}
    end
  end
end
