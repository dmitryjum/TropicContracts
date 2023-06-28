class ContractsController < ApplicationController

  def index
    @contracts = Contract.includes(:contract_owner)
    flash.clear
  end

  def supplier
    flash.now[:alert] = "Supplier"
    @supplier_name = params[:supplier_name]
    @contracts = Contract.includes(:contract_owner).where(supplier: @supplier_name)
    @avg_contract_value = Contract.avg_value_per_supplier(@supplier_name)
  end

  def import_csv
    return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
    return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'
    import_service = CsvContractImportService.new(params[:file])
    import_service.call
    @contracts = Contract.includes(:contract_owner)
    @updated_or_created_counter = import_service.updated_contracts_counter
    @invalid_records = import_service.invalid_contract_instances
    flash.now[:notice] = "#{@updated_or_created_counter} records have been updated successfuly" if @updated_or_created_counter > 0
    flash.now[:alert] = {invalid_records: @invalid_records} if @invalid_records.size > 0
    respond_to do |format|
      format.turbo_stream
    end
  end
end
