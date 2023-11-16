class ApplicationController < ActionController::Base
    include ParameterErrorHandlerConcern
    include LoggerableConcern
end
