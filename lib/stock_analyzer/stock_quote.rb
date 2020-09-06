class StockQuote

  attr_accessor :date, :open

  def self.parse(date:, open:)
    new(
      date: Date.parse(date),
      open: BigDecimal(open),
    )
  end

  def initialize(date:, open:)
    self.date = date
    self.open = open
  end

  def relevant?(start_date, end_date)
    date.between?(start_date, end_date) && open.present?
  end

end
