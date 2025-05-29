class Task < ApplicationRecord
  before_create :generate_uuid

  enum :priority, { low: "Low", medium: "Medium", high: "High" }
	enum :status, { pending: "Pending", completed: "Completed" }

  validates :title, presence: true
  validates :due_date, presence: true

  private

  def generate_uuid
    self.id ||= SecureRandom.uuid
  end
end
