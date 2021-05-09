class Reservation < ApplicationRecord
  validates :start_date,
            presence: true
  validates :end_date,
            presence: true
  validate :start_must_be_before_end_date
  validates_each :start_date, :end_date do |record, attr, value|
    record.errors.add(attr, 'The accommodation is already booked on this date!') if record.accommodation.overlaping_reservation?(value)
  end
  belongs_to :guest, class_name: "User"
  belongs_to :accommodation
  
  def duration
    (self.end_date.to_f - self.start_date.to_f) / 1000 # en secondes
  end

  private

  def start_must_be_before_end_date
    return if start_date.blank? || end_date.blank?
    errors.add(:start_date, "must be before end date") unless start_date < end_date
  end
end
