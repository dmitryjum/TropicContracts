require "rails_helper"
shared_examples_for "Contracts Container Component" do
  subject { render_inline(described_class.new(contracts: contracts)) }

  let(:contracts) { [double("Contract")] }

  it "renders headers row correctly" do
    expect(subject).to have_selector(".card-container")
    expect(subject).to have_selector("#contracts", text: "Contract Row Rendered")

    expect(subject).to have_selector(".table-cell", text: "Contract Owner")
    expect(subject).to have_selector(".table-cell", text: "Contract Name")
    expect(subject).to have_selector(".table-cell", text: "Start Date")
    expect(subject).to have_selector(".table-cell", text: "End Date")
    expect(subject).to have_selector(".table-cell", text: "Contract Value")
    expect(subject).to have_selector(".table-row", count: 1)
  end
end

RSpec.describe ContractsContainerComponent, type: :component do
  let(:contracts) { [double("Contract")] }
  let(:contract_row_stub_text) { "Contract Row Rendered" }

  before do
    allow_any_instance_of(ContractRowComponent).to receive(:render_in).and_return(contract_row_stub_text)
  end

  it_behaves_like "Contracts Container Component"

  it "renders the component with contracts and supplier name" do
    rendered_component = render_inline(described_class.new(contracts: contracts, supplier_name: "ACME Corp"))

    expect(rendered_component).to have_selector(".hidden", text: "Supplier")
  end

  it "renders the component with contracts and no supplier name" do
    rendered_component = render_inline(described_class.new(contracts: contracts))
    expect(rendered_component).not_to have_selector(".hidden")
  end
end
