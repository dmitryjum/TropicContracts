require "rails_helper"

RSpec.describe ContractsContainerComponent, type: :component do
  context "with contracts and supplier name" do
    it "renders the component with the supplied data" do
      contracts = [double("Contract")]
      supplier_name = "ACME Corp"
      allow_any_instance_of(ContractRowComponent).to receive(:render_in).and_return("Contract Row Rendered")
      rendered_component = render_inline(described_class.new(contracts: contracts))

      expect(rendered_component).to have_selector(".card-container")
      expect(rendered_component).to have_selector("#contracts")

      expect(rendered_component).to have_selector(".table-cell", text: "Contract Owner")
      expect(rendered_component).to have_selector(".table-cell", text: "Supplier")
      expect(rendered_component).to have_selector(".table-cell", text: "Contract Name")
      expect(rendered_component).to have_selector(".table-cell", text: "Start Date")
      expect(rendered_component).to have_selector(".table-cell", text: "End Date")
      expect(rendered_component).to have_selector(".table-cell", text: "Contract Value")

      expect(rendered_component).to have_selector(".table-row", count: 1)
      expect(rendered_component).to have_content("ACME Corp")
    end
  end
end