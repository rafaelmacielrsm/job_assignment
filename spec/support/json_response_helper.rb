module JsonResponse
  module Helpers
    # As stated in the json api v1.0 specification, a json document must have
    # at least one top-level member

    # This extract and symbolize the attributes from the response
    def json_response
      @json_data ||= JSON.parse(response.body, symbolize_names: true)
    end

    # This helper extract the 'data' top-level member
    def json_data_member
      json_response[:data]
    end

    # This helper extract the 'data' top-level member
    def json_errors_member
      json_response[:errors]
    end

    # This helper extract the attributes information that is inside
    # the data member
    def json_data_attr
      json_response[:data][:attributes]
    end
  end
end
