class ContractOwner < ApplicationRecord
  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}, email: {mode: :strict}

  # Associations
  has_many :contracts
end
