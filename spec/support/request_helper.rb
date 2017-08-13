module Request
  module HeadersHelpers
    def set_default_headers
      request.headers['Accept'] = "application/vnd.api+json"
      request.headers['Content-Type'] = "application/vnd.api+json"
    end
  end
end
