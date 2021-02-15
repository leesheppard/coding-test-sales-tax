require_relative "../lib/import"

describe "import" do
  receipt = ["1 chocolate bar at 0.85", "1 nokia n95 599.99", "1 nokia n95 at 599.99"]
  exclusions = ["chocolate"]

  purchases = Import.new(receipt, exclusions)

  cleaned_receipt = ["1 chocolate bar at 0.85", "1 nokia n95 at 599.99"]
  phone = ["1", "nokia", "n95", "at", "599.99"]
  phone_import = ["1", "imported", "nokia", "n9", "at", "799.99"]
  chocolate = ["1", "chocolate", "bar", "at", "0.85"]

  result_hash = [{ name: "chocolate bar", qty: 1, price: 0.85, good: false, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85 }]

  it "only captures items with 'at' inside it" do
    expect(purchases.capture(receipt)).to eq(["1 chocolate bar at 0.85", "1 nokia n95 at 599.99"])
  end

  it "cuts up the input item strings array" do
    expect(purchases.cut(cleaned_receipt)).to eq([
                                       ["1", "chocolate", "bar", "at", "0.85"],
                                       ["1", "nokia", "n95", "at", "599.99"]
                                     ])
  end

  it "detects the name:string" do
    expect(purchases.detect_name(phone)).to eq("nokia n95")
  end

  it "detects the qty:integer" do
    expect(purchases.detect_qty(phone)).to eq(1)
  end

  it "detects the price:float" do
    expect(purchases.detect_price(phone)).to eq(599.99)
  end

  it "classifies if the item is a good:boolean" do
    expect(purchases.classify_good(phone)).to eq(true)
    expect(purchases.classify_good(chocolate)).to eq(false)
  end

  it "classifies if the item is a import:boolean" do
    expect(purchases.classify_import(phone)).to eq(false)
    expect(purchases.classify_import(phone_import)).to eq(true)
  end

  it "returns 0.0 for value" do
    expect(purchases.value).to eq(0.0)
  end

  it "adds goods_tax:float and import_tax:float together" do
    expect(purchases.sales_tax(2.0, 0.30)).to eq(2.30)
  end

  it "finds the total of qty * price + sales_tax" do
    expect(purchases.calculate_total(phone, 0.0)).to eq(599.99)
  end

  it "detects the items and build a hash made up of item name:string, qty:integer, price:float, good:boolean, import:boolean, total:float" do
    expect(purchases.detect(chocolate)).to eq(result_hash[0])
  end

  it "updates the list of items" do
    list = []
    purchases.update_items(chocolate, list)
    expect(list).to eq(result_hash)
  end

  it "parses the list of items purchased" do
    expect(purchases.parser(receipt)).to eq([{ name: "chocolate bar", qty: 1, price: 0.85, good: false, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85 }, { name: "nokia n95", qty: 1, price: 599.99, good: true, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 599.99 }])
  end

  it "sets qty to 0 if there is no integer" do
    zero_qty_item = ["zero nothing here at 9.99", "1 nokia n95 at 599.99"]
    expect(purchases.parser(zero_qty_item)).to eq([{ name: "nothing here", qty: 0, price: 9.99, good: true, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.0 }, { name: "nokia n95", qty: 1, price: 599.99, good: true, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 599.99 }])
  end

  it "sets price to 0 if there is no float" do
    no_price = ["1 nothing here at zero"]
    expect(purchases.parser(no_price)).to eq([{ name: "nothing here", qty: 1, price: 0.0, good: true, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.0 }])
  end

  it "selects items with a qty > 0" do
    no_qty = [ { name: "nothing here", qty: 0, price: 9.99, good: true, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.0 }, { name: "nokia n95", qty: 1, price: 599.99, good: true, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 599.99 } ]
    expect(purchases.clean(no_qty)).to eq([{ name: "nokia n95", qty: 1, price: 599.99, good: true, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 599.99 }])
  end

  it "takes the receipt, and exclusions and be able to generate a finalized output of items with a qty > 0" do
    receipt = ["1 chocolate bear at 0.85", "1 imported goldfish at 599.99", "1 bullfrog at 10.99", "there is nothing here", "zeros here at 9.99"]
    exclusions = ["chocolate"]
    purchases = Import.new(receipt, exclusions)
    expect(purchases.generate).to eq([{ name: "chocolate bear", qty: 1, price: 0.85, good: false, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85 }, { name: "imported goldfish", qty: 1, price: 599.99, good: true, import: true, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 599.99 }, { name: "bullfrog", qty: 1, price: 10.99, good: true, import: false, goods_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 10.99 }])
  end
end
