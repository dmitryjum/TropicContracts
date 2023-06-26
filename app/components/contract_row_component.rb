class ContractRowComponent < ViewComponent::Base
  include TableHelper
  with_collection_parameter :contract
  attr_reader :contract, :supplier_name

  def initialize(contract:, supplier_name: nil)
    @contract = contract
    @supplier_name = supplier_name
  end
end