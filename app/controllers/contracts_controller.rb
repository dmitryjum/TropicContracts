class ContractsController < ApplicationController
  include Pagy::Backend


  def index
    @pagy, @contracts = pagy(Contract.includes(:contract_owner), items: 7)
    flash.clear
  end

  def supplier
    request.variant = :turbo_frame if turbo_frame_request?
    @supplier_name = params[:supplier_name]
    contracts_by_supplier = Contract.includes(:contract_owner).by_supplier(@supplier_name)
    @pagy, @contracts = pagy(contracts_by_supplier, items: 7)
    @avg_contract_value = Contract.avg_value_per_supplier(supplier: @supplier_name, collection: contracts_by_supplier)
    flash.clear
  end

  def import_csv
    begin
      return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
      return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'
      import_service = CsvContractImportService.new(params[:file])
      import_service.call
      @pagy, @contracts = pagy(Contract.includes(:contract_owner), items: 7)
      @updated_or_created_counter = import_service.updated_contracts_counter
      @invalid_records = import_service.invalid_contract_instances
      flash.now[:notice] = "#{@updated_or_created_counter} records have been created or updated successfuly" if @updated_or_created_counter > 0
      flash.now[:alert] = {invalid_records: @invalid_records} if @invalid_records.size > 0
      respond_to do |format|
        format.turbo_stream
      end
    rescue => e
      #but things like these should be caught with middlware error logging service and reported (HoneyBadger, Rollbar, etc)
      render :index, status: :unprocessable_entity
    end
  end
end
