class ContractsController < ApplicationController
  def index
    @contracts = Contract.includes(:contract_owner)
  end

  def supplier
    @supplier_name = params[:supplier_name]
    @contracts = Contract.includes(:contract_owner).where(supplier: @supplier_name)
    @avg_contract_value = Contract.avg_value_per_supplier(@supplier_name)
  end
end
