class Exam < ApplicationRecord
  has_many :users
  has_one :exam_window

  belongs_to :college

  validates :subject, presence: true
end
