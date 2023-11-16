class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create

    def create
        service = CreateUserService.new(user_params)
        user = service.process
        if service.errors.present?
            log_api_request(service.errors.join(", "))
            render status: :bad_request, json: { errors: service.errors }
        else
            log_api_request
            render status: :ok, json: { user: user }
        end
    end

    private

        def user_params
            params.require(:user).permit(:first_name, :last_name, :phone_number, :college_id, :exam_id, :start_time)
        end
end