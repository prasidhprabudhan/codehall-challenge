require "test_helper"

class ExamTest < ActiveSupport::TestCase
  def setup
    college = create :college
    @exam = create :exam, college: college
  end

  def test_subject_is_present
    @exam.subject = ""

    assert_not @exam.valid?
    assert @exam.errors.added?(:subject, :blank)
  end

  def test_exam_belongs_to_a_college
    exam = Exam.create(subject: Faker::Educator.subject)

    assert_not exam.valid?
    assert_includes exam.errors.full_messages, "College must exist"
  end
end
