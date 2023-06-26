class ContractsContainerComponent < ViewComponent::Base
  include TableHelper
  attr_reader :contracts, :supplier_name
  renders_one :top_header
  renders_one :back_button
  
  def initialize(contracts: [], supplier_name: nil)
    @contracts = contracts
    @supplier_name = supplier_name
  end
end