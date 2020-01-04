class SingleTradeProfitAnalyzer

  attr_accessor :start_date, :end_date, :stock_symbol, :stock_quotes

  def initialize(start_date, end_date, stock_symbol, stock_quotes)
    self.start_date = start_date
    self.end_date = end_date
    self.stock_symbol = stock_symbol
    self.stock_quotes = stock_quotes
  end

  def analyze
    bought_for = stock_quotes.find { |stock_quote| stock_quote.date == start_date }.open
    sold_for = stock_quotes.find { |stock_quote| stock_quote.date == end_date }.open

    { stock_symbol => sold_for - bought_for }
  end

end
