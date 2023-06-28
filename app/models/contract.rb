class Contract < ApplicationRecord
  # Validations
  validates :external_contract_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, comparison: {greater_than: :start_date}
  validates :value_cents, presence: true, numericality: {greater_than: 0}

  # Associations
  belongs_to :contract_owner

  monetize :value_cents

  scope :by_supplier, ->(supplier) { where("to_tsvector('english', supplier) @@ plainto_tsquery('english', :q)", q: supplier) }

  def self.avg_value_per_supplier(supplier)
    Money.new(Contract.where(supplier:).average(:value_cents)).format
  end

end
