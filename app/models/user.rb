class User < ApplicationRecord
  belongs_to :college
  belongs_to :exam

  has_one :exam_window, through: :exam

  validates :first_name, presence: true
  validates :phone_number, presence: true
  validate :check_if_start_time_falls_in_exam_window, if: :exam_window

  private

    def check_if_start_time_falls_in_exam_window
      start_date = exam_window.start_date
      end_date = exam_window.end_date
      range = start_date..end_date

      unless range.cover?(start_time)
        errors.add(:start_time, "must fall within the date range of #{start_date} to #{end_date}")
      end
    end
end
