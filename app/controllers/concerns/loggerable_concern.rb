# app/controllers/concerns/parameter_errors_handling_concern.rb
module LoggerableConcern
    extend ActiveSupport::Concern
  
    private
  
        def log_api_request(error_message = "")
            ApiRequest.create!(
                request_method: request.method,
                endpoint: request.path,
                parameters: request.parameters.to_json,
                error_message:
            )
        end
end
  