class SingleTradeProfitAnalyzer

  attr_accessor :stock_symbol, :stock_quotes

  def initialize(stock_symbol:, stock_quotes:)
    self.stock_symbol = stock_symbol
    self.stock_quotes = stock_quotes
  end

  def analyze
    total = if stock_quotes.present?
      stock_quotes.last.open - stock_quotes.first.open
    else
      BigDecimal('0')
    end

    { stock_symbol => total }
  end

end
