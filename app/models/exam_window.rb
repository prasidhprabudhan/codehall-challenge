class ExamWindow < ApplicationRecord
  belongs_to :exam

  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :start_date_before_end_date

  private

    def start_date_before_end_date
      if start_date.present? && end_date.present? && start_date > end_date
        errors.add(:start_date, "must be before the end date")
      end
    end
end
