class ContractsController < ApplicationController
  def index
    @contracts = Contract.includes(:contract_owner)
  end

  def import_modal
    @contract = Contract.new
  end

  def supplier
    @supplier_name = params[:supplier_name]
    @contracts = Contract.includes(:contract_owner).where(supplier: @supplier_name)
    @avg_contract_value = Contract.avg_value_per_supplier(@supplier_name)
  end

  def import_csv
    @contracts = CsvContractImportService.new(params[:file]).call
    return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
    return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'
    respond_to do |format|
      format.html { redirect_to messages_path }
      format.turbo_stream
    end
  end
end
