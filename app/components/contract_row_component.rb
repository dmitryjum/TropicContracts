class ContractRowComponent < ViewComponent::Base
  include TableHelper
  with_collection_parameter :contract
  attr_reader :contract, :supplier_view

  def initialize(contract:, supplier_view: false)
    @contract = contract
    @supplier_view = supplier_view
  end
end