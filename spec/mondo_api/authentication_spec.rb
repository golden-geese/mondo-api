require "ostruct"
require 'spec_helper'

module MondoApi
  describe Authentication do
    it "raises an error if the request doesn't succeed" do
      http_client = double("HttpClient", post: double(success?: false, "[]": nil))

      auth = described_class.new(http_client: http_client,
                                 client_id: "client-id",
                                 client_secret: "client_secret")

      expect(auth.get_access_token("authorization token", "redirect-uri").success?).to be false
    end

    it 'exchanges a authorization token for an access token' do
      access_token = "access-token"
      http_client = double(post: OpenStruct.new(access_token: access_token,
                                                success?: true))
      auth = described_class.new(http_client: http_client,
                                 client_id: "client-id",
                                 client_secret: "client-secret")
      query = {
        grant_type: "authorization_code",
        client_id: "client-id",
        client_secret: "client-secret",
        redirect_uri: "redirect-uri",
        code: "authorization token"
      }

      expect(auth.get_access_token("authorization token", "redirect-uri").body).to eq(access_token)
      expect(http_client).to have_received(:post).
                              with("https://api.getmondo.co.uk/oauth2/token",
                                   body: query,
                                   headers: {"Content-Type"=>"application/x-www-form-urlencoded"})
    end
  end
end
