require_relative "../lib/input"
require_relative "../lib/import"
require_relative "../lib/calculator"
require_relative "../lib/output"
require_relative "../lib/apply_tax"

RSpec.describe "Apply appropriate taxes" do
  it "returns output 1" do
    purchases = ApplyTax.new("input1.txt")
    expect(purchases.execute.output).to eq([
                                        "1 book: 12.49",
                                        "1 music cd: 16.49",
                                        "1 chocolate bar: 0.85",
                                        "Sales Total: 1.50",
                                        "Total: 29.83"
                                        ])
  end

  it "returns output 2" do
    purchases = ApplyTax.new("input2.txt")
    expect(purchases.execute.output).to eq([
                                        "1 imported box of chocolates: 10.50",
                                        "1 imported bottle of perfume: 54.65",
                                        "Sales Total: 7.65",
                                        "Total: 65.15"
                                        ])
  end

  it "returns output 3" do
    purchases = ApplyTax.new("input3.txt")
    expect(purchases.execute.output).to eq([
                                        "1 imported bottle of perfume: 32.19",
                                        "1 bottle of perfume: 20.89",
                                        "1 packet of headache pills: 9.75",
                                        "1 box of imported chocolates: 11.85",
                                        "Sales Total: 6.70",
                                        "Total: 74.68"
                                        ])
  end
end
