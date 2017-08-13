# This initializer adds the 'application/vnd.api+json' to the json myme types
# That way it is in accordance to json api v1.0 specification
api_mime_types = %W(
  application/vnd.api+json
  text/x-json
  application/json
  application/jsonrequest
)

Mime::Type.unregister :json
Mime::Type.register 'application/json', :json, api_mime_types
