# app/controllers/concerns/parameter_errors_handling_concern.rb
module ParameterErrorHandlerConcern
    extend ActiveSupport::Concern
  
    included do
      rescue_from ActionController::UnpermittedParameters, with: :handle_unpermitted_parameters
    end
  
    private
  
    def handle_unpermitted_parameters(exception)
      error = t('errors.bad_request', params: exception.params.to_sentence )
      log_api_request(error)
      
      render json: { error: }, status: :bad_request
    end
end
  