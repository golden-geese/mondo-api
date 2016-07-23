require 'spec_helper'

module MondoApi
  RSpec.describe Accounts do
    let(:access_token) { "123abc" }

    it "returns a list of user accounts" do
      accounts_list = {"accounts" => [{
                                        "id": "acc_00009237aqC8c5umZmrRdh",
                                       "description": "Peter Pan's Account",
                                       "created": "2015-11-13T12:17:42Z"
                                      }]}

      http_client = double("HttpClient",
                           get: OpenStruct.new(success?: true, body: accounts_list))
      accounts = described_class.new(http_client: http_client, access_token: access_token)

      expect(accounts.list.body).to eq accounts_list["accounts"]
    end
  end
end
