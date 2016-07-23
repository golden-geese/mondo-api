require 'spec_helper'

module MondoApi
  RSpec.describe Webhooks do
    let(:access_token) {"access_token"}
    let(:mondo_account_id) {"mondo_account_id"}
    let(:callback_url) { "url" }

    it "raises an error if the register request doesn't succeed" do
      http_client = double("HttpClient", post: double(success?: false))

      webhook = described_class.new(http_client: http_client)

      expect { webhook.register(access_token, mondo_account_id, callback_url) }
        .to raise_exception(MondoApi::RequestError)
    end

    it "raises an error if the list request doesn't succeed" do
      http_client = double("HttpClient", get: double(success?: false))

      webhook = described_class.new(http_client: http_client)

      expect { webhook.list(access_token, mondo_account_id) }
        .to raise_exception(MondoApi::RequestError)
    end

    it "makes a request to register a webhook with correct token" do
      http_client = double("HttpClient", post: double(success?: true))
      webhook = described_class.new(http_client: http_client)
      body = {
        account_id: mondo_account_id,
        url: callback_url
      }
      headers = { "Authorization" => "Bearer #{access_token}" }

      expect(http_client).to receive(:post).with(Webhooks::WEBHOOK_URL,
                                                 body: body,
                                                 headers: headers)

      webhook.register(access_token, mondo_account_id, callback_url)
    end

    it "makes a request to the webhooks listing" do
      webhooks = [{ "account_id" => mondo_account_id, "url" => callback_url }]
      http_client = double("HttpClient",
                           get: OpenStruct.new(success?: true, webhooks: webhooks))
      webhook = described_class.new(http_client: http_client)
      body = { account_id: mondo_account_id }
      headers = { "Authorization" => "Bearer #{access_token}" }

      expect(http_client).to receive(:get).with(Webhooks::WEBHOOK_URL,
                                                body: body,
                                                headers: headers)

      expect(webhook.list(access_token, mondo_account_id)).to eq(webhooks)
    end
  end
end
