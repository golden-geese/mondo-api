require "httparty"

require "mondo_api/response"
require "mondo_api/authentication"
require "mondo_api/webhooks"
require "mondo_api/accounts"
require "mondo_api/client"

module MondoApi
  VERSION="0.1.0"

  class RequestError < StandardError; end
end
