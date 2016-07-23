require 'spec_helper'

module MondoApi
  RSpec.describe Webhooks do
    let(:access_token) {"access_token"}
    let(:account_id) {"mondo_account_id"}
    let(:callback_url) { "url" }

    it "returns a failed response if the register request doesn't succeed" do
      http_client = double("HttpClient", post: double(success?: false))

      webhook = described_class.new(http_client: http_client, access_token: access_token, account_id: account_id)

      expect(webhook.register(callback_url).success?).to be false
    end

    it "returns a failed response if the list request doesn't succeed" do
      http_client = double("HttpClient", get: double(success?: false, "[]": nil))

      webhook = described_class.new(http_client: http_client, access_token: access_token, account_id: account_id)

      expect(webhook.list.success?).to be false
    end

    it "makes a request to register a webhook with correct token" do
      http_client = double("HttpClient", post: double(success?: true))
      webhook = described_class.new(http_client: http_client, access_token: access_token, account_id: account_id)
      body = {
        account_id: account_id,
        url: callback_url
      }
      headers = { "Authorization" => "Bearer #{access_token}" }

      expect(http_client).to receive(:post).with(Webhooks::WEBHOOK_URL,
                                                 body: body,
                                                 headers: headers)

      webhook.register(callback_url)
    end

    it "makes a request to the webhooks listing" do
      webhooks = [{ "account_id" => account_id, "url" => callback_url }]
      http_client = double("HttpClient",
                           get: OpenStruct.new(success?: true, webhooks: webhooks))
      webhook = described_class.new(http_client: http_client, access_token: access_token, account_id: account_id)
      headers = { "Authorization" => "Bearer #{access_token}" }

      expect(http_client).to receive(:get).with("#{Webhooks::WEBHOOK_URL}?account_id=#{account_id}",
                                                headers: headers)

      expect(webhook.list.body).to eq(webhooks)
    end
  end
end
