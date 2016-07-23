module MondoApi
  class Response
    attr_reader :body

    def initialize(success:, body:)
      @success = success
      @body = body
    end

    def success?
      @success
    end
  end
end
