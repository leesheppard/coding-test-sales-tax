require_relative "../lib/input"

RSpec.describe "input" do
  purchases = Input.new("input1.txt")

  it "takes input file and turns it into an array" do
    expect(purchases.items.class).to eq(Array)
  end

  it "takes the exclusions file and turns it into an array" do
    expect(purchases.exclusions.class).to eq(Array)
  end
end
