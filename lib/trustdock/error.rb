module Trustdock
  class Error < StandardError; end

  class ClientError < Error; end
  class ServerError < Error; end

  class UnauthorizedError < ClientError; end
  class NotFoundError < ClientError; end
  class UnprocessableEntityError < ClientError; end

  class InternalServerError < ServerError; end
  class ServiceUnavailableError < ServerError; end
end
