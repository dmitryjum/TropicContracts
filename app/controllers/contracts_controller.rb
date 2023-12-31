class ContractsController < ApplicationController
  include Pagy::Backend


  def index
    @session_id = session.id.to_s
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
      CsvContractImportService.new(params[:file], session.id.to_s).call
      flash.now[:notice] = "The CSV import has begun and in process right now"
      respond_to do |format|
        format.turbo_stream
      end
    rescue => e
      Rails.logger.warn(e)
      #but things like these should be caught with middlware error logging service and reported (HoneyBadger, Rollbar, etc)
      render :index, status: :unprocessable_entity
    end
  end
end
