require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @college = create :college
    @exam = create :exam, college: @college
    @exam_window = create :exam_window, exam: @exam
    @user = create :user, college: @college, exam: @exam
  end

  def test_first_name_is_present
    @user.first_name = ""

    assert_not @user.valid?
    assert @user.errors.added?(:first_name, :blank)
  end

  def test_phone_number_is_present
    @user.phone_number = ""

    assert_not @user.valid?
    assert @user.errors.added?(:phone_number, :blank)
  end

  def test_user_belongs_to_an_exam
    user = User.create(user_params)

    assert_not user.valid?
    assert_includes user.errors.full_messages, t('errors.exist', column: "Exam")
  end

  def test_user_belongs_to_a_college
    user = User.create(user_params)

    assert_not user.valid?
    assert_includes user.errors.full_messages, t('errors.exist', column: "College")
  end

  def test_start_time_falls_in_exam_window
    user = build :user, exam: @exam, college: @college, start_time: @exam_window.start_date - 1

    assert_not user.valid?

    assert_includes user.errors.messages[:start_time], 
      t('models.user.start_time', start_date: @exam_window.start_date, end_date: @exam_window.end_date)
  end

  private

    def user_params
      {
        first_name: Faker::Name.first_name,
        phone_number: Faker::PhoneNumber.phone_number
      }
    end
end
