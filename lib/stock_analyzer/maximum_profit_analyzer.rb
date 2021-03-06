class MaximumProfitAnalyzer

  attr_accessor :stock_symbol, :stock_quotes

  def initialize(stock_symbol:, stock_quotes:)
    self.stock_symbol = stock_symbol
    self.stock_quotes = stock_quotes
  end

  # Adapted from https://www.algoexpert.io/questions/Max%20Profit%20With%20K%20Transactions
  def analyze
    return result(BigDecimal('0')) if stock_quotes.count < 2

    prices = stock_quotes.map(&:open)

    profits = Array.new(prices.size + 1) { Array.new(prices.size, 0) }
    maximum_transactions = prices.size

    (1..maximum_transactions).each do |number_of_transactions|
      current_maximum = BigDecimal('-Infinity')

      (1..(prices.size - 1)).each do |day|
        current_maximum = [
          current_maximum,
          profits[number_of_transactions - 1][day - 1] - prices.at(day - 1),
        ].max

        profits[number_of_transactions][day] = [
          profits[number_of_transactions][day - 1],
          current_maximum + prices.at(day),
        ].max
      end
    end

    result(profits[maximum_transactions][prices.size - 1])
  end

  private

  def result(total)
    { stock_symbol => total }
  end

end
