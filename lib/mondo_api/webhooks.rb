module MondoApi
  class Webhooks
    WEBHOOK_URL = "https://api.getmondo.co.uk/webhooks"

    def initialize(http_client: HTTParty)
      @http_client = http_client
    end

    def register(access_token, mondo_account_id, callback_url)
      response = @http_client.post(WEBHOOK_URL,
                                   body: body(mondo_account_id, callback_url),
                                   headers: headers(access_token))

      raise RequestError unless response.success?
    end

    def list(access_token, mondo_account_id)
      response = @http_client.get(WEBHOOK_URL,
                                  body: { account_id: mondo_account_id },
                                  headers: headers(access_token))
      raise RequestError unless response.success?

      response["webhooks"]
    end

    private

    def body(mondo_account_id, callback_url)
      { account_id: mondo_account_id, url: callback_url }
    end

    def headers(access_token)
      {"Authorization" => "Bearer #{access_token}"}
    end
  end
end
