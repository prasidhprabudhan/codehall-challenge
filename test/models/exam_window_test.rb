require "test_helper"

class ExamWindowTest < ActiveSupport::TestCase
  def setup
    college = create :college
    exam = create :exam, college: college
    @exam_window = create :exam_window, exam: exam
  end

  def test_exam_start_date_is_present
    @exam_window.start_date = ""

    assert_not @exam_window.valid?
    assert @exam_window.errors.added?(:start_date, :blank)
  end

  def test_exam_end_date_is_present
    @exam_window.end_date = ""

    assert_not @exam_window.valid?
    assert @exam_window.errors.added?(:end_date, :blank)
  end

  def test_exam_window_belongs_to_an_exam
    exam_window = ExamWindow.create(
      start_date: 10.days.ago, 
      end_date: 10.days.from_now
    )

    assert_not exam_window.valid?
    assert_includes exam_window.errors.full_messages, "Exam must exist"
  end

  def test_exam_window_is_invalid_when_start_date_is_after_end_date
    exam_window = build :exam_window, start_date: Date.today + 1.day, end_date: Date.today
    assert_not exam_window.valid?
    assert_includes exam_window.errors.full_messages, 'Start date must be before the end date'
  end
end
