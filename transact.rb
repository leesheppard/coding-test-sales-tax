require_relative "./lib/input"
require_relative "./lib/apply_tax"
require_relative "./lib/calculator"
require_relative "./lib/import"
require_relative "./lib/output"

filename = ARGV.first
purchase = ApplyTax.new(filename)
purchase.execute
