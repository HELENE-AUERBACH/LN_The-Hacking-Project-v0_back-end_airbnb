class Accommodation < ApplicationRecord
  validates :available_beds,
            numericality: { only_integer: true, greater_than: 0 },
            presence: true
  validates :price,
            numericality: { only_integer: true, greater_than: 0 },
            presence: true
  validates :description,
            length: { minimum: 140 },
            presence: true
  validates :has_wifi,
            exclusion: [nil]
  validates :welcome_message,
            presence: true
  belongs_to :admin, class_name: "User"
  has_many :reservations
  belongs_to :city

  def overlaping_reservation?(datetime)
    # vérifie dans toutes les réservations de l'accommodation s'il y a une réservation qui tombe sur le datetime en entrée
    result = false
    if !self.nil? && !self.reservations.nil?
      self.reservations.each do |res|
        result = datetime.between?(res.start_date, res.end_date)
        if result
          break
        end
      end
    end
    result
  end
end
