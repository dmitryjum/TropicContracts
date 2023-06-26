class ContractsContainerComponent < ViewComponent::Base
  include TableHelper
  attr_reader :contracts, :supplier_view
  
  def initialize(contracts: [], supplier_view: false)
    @contracts = contracts
    @supplier_view = supplier_view
  end
end