class FlashAlertComponent < ViewComponent::Base
  attr_reader :invalid_records_alert
  def initialize(alert: nil)
    @invalid_records_alert = alert[:invalid_records]
  end
end