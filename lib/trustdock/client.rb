module Trustdock
  class Client
    PRODUCTION_URL = "https://api.trustdock.io"
    SANDBOX_URL    = "https://api.test.trustdock.io"

    attr_reader :last_response

    def initialize(api_token, sandbox: false)
      @api_token = api_token
      @sandbox = sandbox
    end

    def verification(id)
      @last_response = request(:get, "/v2/verifications/#{id}")

      Response::Verification.new JSON.parse(@last_response.body, symbolize_names: true)
    end

    def create_verification(options = {})
      @last_response = request(:post, "/v2/verifications", options)

      Response::Verification.new JSON.parse(@last_response.body, symbolize_names: true)
    end

    def update_plan(verification_id, options)
      @last_response = request(:put, "/v2/verifications/#{verification_id}/plans", options)

      nil
    end

    def update_document(verification_id, plan_id, options)
      @last_response = request(:put, "/v2/verifications/#{verification_id}/plans/#{plan_id}/documents", options)

      nil
    end

    def update_comparing_data(verification_id, options)
      @last_response = request(:put, "/v2/verifications/#{verification_id}/comparing_data", options)

      nil
    end

    private

    def request(method, path, options = nil)
      client.send(method, path, (options) ? options.to_json : nil)

    rescue Faraday::Error => e
      @last_response = e.response

      case e.response[:status]
      when 401
        raise UnauthorizedError
      when 404
        raise NotFoundError
      when 422
        raise UnprocessableEntityError
      when 500
        raise InternalServerError
      when 503
        raise ServiceUnavailableError
      end
    end

    def client
      @client ||= Faraday.new(api_url) do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.authorization :Bearer, @api_token
        conn.response :raise_error
        conn.adapter Faraday.default_adapter
      end
    end

    def api_url
      @sandbox ? SANDBOX_URL : PRODUCTION_URL
    end
  end
end
