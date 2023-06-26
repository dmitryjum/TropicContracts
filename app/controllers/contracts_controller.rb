class ContractsController < ApplicationController
  def index
    @contracts = Contract.includes(:contract_owner)
  end
end
