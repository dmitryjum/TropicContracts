class ContractsController < ApplicationController
  def index
    @contracts = Contract.includes(:contract_owner)
  end

  def new
    @contract = Contract.new
  end
end
