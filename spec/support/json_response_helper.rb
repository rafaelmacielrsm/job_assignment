module JsonResponse
  module Helpers
    # As stated in the json api v1.0 specification, a json document must have
    # at least one top-level member

    # This extracts and symbolizes the attributes from the response
    def json_response
      @json_data ||= JSON.parse(response.body, symbolize_names: true)
    end

    # This helper extracts the 'data' top-level member
    def json_data_member
      json_response[:data]
    end
    def json_errors_member
      json_response[:errors]
    end
  end
end
