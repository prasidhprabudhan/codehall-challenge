# app/controllers/concerns/parameter_errors_handling_concern.rb
module ParameterErrorHandlerConcern
    extend ActiveSupport::Concern
  
    included do
      rescue_from ActionController::UnpermittedParameters, with: :handle_unpermitted_parameters
    end
  
    private
  
    def handle_unpermitted_parameters(exception)
      render json: { error: "Bad Request - Unpermitted parameters: #{exception.params}" }, status: :bad_request
    end
end
  