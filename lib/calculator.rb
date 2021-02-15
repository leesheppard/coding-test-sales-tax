class Calculator
  attr_reader :items, :total_all, :sales_tax

  def initialize(items)
    @items = items
    @goods_tax_rate = 0.10
    @import_tax_rate = 0.05
    @nearest_cent = 1 / 0.05
    @total_all = 0.0
    @sales_tax = 0.0
  end

  def execute
    update_amounts
    set_totals
  end

  def update_amounts
    @items = @items.each do |item|
      item[:goods_tax] = set_tax(item[:good], item[:total], @goods_tax_rate)
      item[:import_tax] = set_tax(item[:import], item[:total], @import_tax_rate)
      item[:sales_tax] = add_taxes(item[:sales_tax], item[:goods_tax], item[:import_tax])
      item[:total] = add_taxes(item[:total], item[:goods_tax], item[:import_tax])
    end
  end

  def set_tax(status, base_total, tax_rate)
    if status == true
      amt = compute_tax(base_total, tax_rate)
      round_tax(amt)
    else
      0.0
    end
  end

  def get_tax(item_price, tax_rate)
    amt = compute_tax(item_price, tax_rate)
    round_tax(amt)
  end

  def compute_tax(item_price, tax_rate)
    item_price * tax_rate
  end

  def round_tax(amt)
    ((amt * @nearest_cent).ceil / @nearest_cent)
  end

  def add_taxes(amt, goods_tax, import_tax)
    amt += goods_tax + import_tax
    amt.round(2)
  end

  def set_totals
    @sales_tax = compute_total("sales_tax")
    @total_all = compute_total("total")
  end

  def compute_total(type)
    list = capture_amounts(type)
    generate_total(list)
  end

  def capture_amounts(type)
    @items.map { |key, _| key[type.to_sym] }
  end

  def generate_total(list)
    list.inject(:+).round(2)
  end
end
