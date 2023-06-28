class FlashAlertComponent < ViewComponent::Base
  def initialize(alert: nil)
    @alert = alert
  end

  def invalid_csv_rows
    debugger
  end
end