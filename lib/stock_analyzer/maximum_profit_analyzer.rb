class MaximumProfitAnalyzer

  attr_accessor :start_date, :end_date, :stock_name, :stock_quotes

  def initialize(start_date, end_date, stock_name, stock_quotes)
    self.start_date = start_date
    self.end_date = end_date
    self.stock_name = stock_name
    self.stock_quotes = stock_quotes
  end

  # Adapted from https://www.algoexpert.io/questions/Max%20Profit%20With%20K%20Transactions
  def analyze
    prices = stock_quotes.select { |stock_quote| (start_date..end_date).cover?(stock_quote.date) }.map(&:open)
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

    { stock_name => profits[maximum_transactions][prices.size - 1] }
  end

end
