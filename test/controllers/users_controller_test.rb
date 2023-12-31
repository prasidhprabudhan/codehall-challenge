# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    def setup
        @college = create :college
        @exam = create :exam, college: @college
        @exam_window = create :exam_window, exam: @exam
    end

    def test_user_is_created_if_not_found_in_database
        assert_difference -> { @college.users.reload.size } do
            post users_path, params: user_params
        end
        
        assert_equal @college.id, json_body["user"]["college_id"]
    end

    def test_user_is_found_if_it_already_exist_in_database
        @user = create :user, college: @college, exam: @exam
        payload = { user: @user.attributes.except("id", "created_at", "updated_at") }
        assert_no_difference -> { @college.users.reload.size } do
            post users_path, params: payload
        end

        assert_response :ok
        assert_equal @user.id, json_body["user"]["id"]
    end

    def test_create_should_return_error_if_first_name_is_blank
        payload = { user: user_params[:user].except(:first_name) }
        assert_no_difference -> { @college.users.reload.size } do
            post users_path, params: payload
        end

        assert_response :bad_request
        assert_includes json_body["errors"], t('errors.presence', column: "First name")
    end

    def test_create_should_return_error_if_phone_number_is_blank
        payload = { user: user_params[:user].except(:phone_number) }
        assert_no_difference -> { @college.users.reload.size } do
            post users_path, params: payload
        end

        assert_response :bad_request
        assert_includes json_body["errors"], t('errors.presence', column: "Phone number")
    end

    def test_user_cannot_be_created_with_invalid_parameters
        assert_no_difference -> { @college.users.reload.size } do
            post users_path, params: { user: { name: Faker::Name.first_name }}
        end

        assert_response :bad_request
        assert_includes json_body["error"], t('errors.bad_request', params: "name")
    end

    def test_user_cannot_be_created_with_invalid_college_id
        assert_no_difference -> { User.count } do
            post users_path, params: { user: { college_id: "Invalid id" }}
        end

        assert_response :bad_request
        assert_includes json_body["errors"], t('errors.not_found', entity: "College")
    end

    def test_user_cannot_be_created_with_invalid_exam_id
        assert_no_difference -> { @college.users.reload.size } do
            post users_path, params: { user: { exam_id: "Invalid id", college_id: @college.id }}
        end

        assert_response :bad_request
        assert_includes json_body["errors"], t('errors.not_found', entity: "Exam")
    end

    def test_user_cannot_be_created_when_given_exam_do_not_belong_to_the_given_college
        college = create :college
        exam = create :exam
        assert_no_difference -> { college.users.reload.size } do
            post users_path, params: { user: { exam_id: exam.id, college_id: college.id }}
        end

        assert_response :bad_request
        assert_includes json_body["errors"], t('errors.not_belong', entity1: "Exam", entity2: "college")
    end

    def test_user_cannot_be_created_when_start_time_do_not_fall_in_the_exam_window
        payload = 
            { 
                user:  
                    {
                        first_name: Faker::Name.first_name,
                        phone_number: Faker::PhoneNumber.phone_number,
                        college_id: @college.id,
                        exam_id: @exam.id,
                        start_time: @exam_window.start_date - 1
                    }
            }
        assert_no_difference -> { @college.users.size } do
            post users_path, params: payload
        end

        assert_response :bad_request
        assert_includes json_body["errors"], 
            "Start time must fall within the date range of #{@exam_window.start_date} to #{@exam_window.end_date}"
    end

    def test_request_is_logged_when_user_is_created
        assert_difference -> { ApiRequest.count } do
            post users_path, params: user_params
        end
    end

    def test_request_is_logged_with_error_message_on_failure_of_create_user_action
        assert_difference -> { ApiRequest.count } do
            post users_path, params: { user: { exam_id: "Invalid id", college_id: @college.id }}
        end

        assert_includes ApiRequest.first.error_message, t('errors.not_found', entity: "Exam")
    end
    
    private

        def user_params
            {
                user:
                    {
                        first_name: Faker::Name.first_name,
                        phone_number: Faker::PhoneNumber.phone_number,
                        start_time: DateTime.now.iso8601,
                        college_id: @college.id,
                        exam_id: @exam.id,
                    }
            }
        end
end
