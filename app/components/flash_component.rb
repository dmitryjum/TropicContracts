class FlashComponent < ViewComponent::Base
  attr_reader :alert, :notice

  def initialize(alert: nil, notice: nil)
    @alert = alert
    @notice = notice
  end
end
