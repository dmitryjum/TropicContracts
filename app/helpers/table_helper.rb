module TableHelper
  def supplier_row_visibility
    "hidden" if supplier_view
  end
end