class ContractRowComponent < ViewComponent::Base
  include TableHelper
  with_collection_parameter :contract
  attr_reader :contract, :supplier_name

  def initialize(contract:, supplier_name: nil)
    @contract = contract
    @supplier_name = supplier_name
  end

  def supplier_view_link
    tag.div class: "table-cell border-t border-gray-300 p-4 pl-8 #{hidden_if(supplier_name)}" do
      link_to contract.supplier,
              supplier_contracts_path(supplier_name: contract.supplier),
              class: "link-text",
              data: { turbo_frame: "table_container" } if contract.supplier.present?
    end
  end
end