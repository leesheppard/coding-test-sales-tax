class Input
  attr_reader :items, :exclusions

  # Import the file from the includes folder and convert to an array
  def itemize(filename)
    File.open(File.dirname(File.dirname(__FILE__)) + "/includes/" + filename).to_a
  end

  # Import list of keyword exclusions for tax
  def initialize(filename)
    @items = itemize(filename)
    @exclusions = build_exclusions(itemize("keyword_exclusions.txt"))
  end

  def build_exclusions(list)
    list.map! { |item| item.chomp.downcase }
  end
end
