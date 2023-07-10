class Contract < ApplicationRecord
  # Validations
  validates :external_contract_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, comparison: { greater_than: :start_date }
  validates :value_cents, presence: true, numericality: { greater_than: 0 }

  # Associations
  belongs_to :contract_owner

  monetize :value_cents

  # scope :by_supplier, ->(supplier) { where("to_tsvector('english', supplier) @@ plainto_tsquery('english', :q)", q: supplier) } --- This one works good and quick, but doesn't pass the test, which would render inaccurate results
  # PGSearch gem uses ranking, which is a bit slower and overkill for just one column
  scope :by_supplier, ->(supplier) { where("supplier ~* ?", supplier) }

  def self.avg_value_per_supplier(supplier:, collection: nil)
    avg = collection.present? ? collection.average(:value_cents) : Contract.by_supplier(supplier).average(:value_cents)
    Money.new(avg).format
  end
end
