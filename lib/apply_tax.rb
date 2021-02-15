require_relative "../lib/input"
require_relative "../lib/import"
require_relative "../lib/calculator"
require_relative "../lib/output"

class ApplyTax
  def initialize(filename)
    @filename = filename
  end

  def input(filename)
    Input.new(filename)
  end

  def parse(file, exclusions)
    list = Import.new(file, exclusions)
    list.generate
    list
  end

  def calc(list)
    costs = Calculator.new(list)
    costs.execute
    costs
  end

  def print(items, sales_tax, total)
    show = Output.new(items, sales_tax, total)
    show.execute
    show
  end

  def execute
    input = input(@filename)
    parsed_list = parse(input.items, input.exclusions)
    calculate = calc(parsed_list.items)
    print(calculate.items, calculate.sales_tax, calculate.total_all)
  end
end
