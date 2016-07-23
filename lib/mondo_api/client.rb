module MondoApi
  class Client
    def initialize(http_client: HTTParty)
      @http_client = http_client
    end

    def webhooks
      Webhooks.new(http_client: @http_client)
    end

    def authentication(client_id:, client_secret:)
      Authentication.new(http_client: @http_client, client_id: client_id, client_secret: client_secret)
    end
  end
end
