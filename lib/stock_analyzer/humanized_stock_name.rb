class HumanizedStockName
  include Singleton

  def self.lookup_database
    StockAnalyzer::DATABASE_DIRECTORY.join('nasdaqlisted.csv')
  end

  attr_accessor :store

  def initialize
    self.store = {}

    CSV.foreach(self.class.lookup_database, headers: true, header_converters: [:downcase, :symbol], col_sep: '|') do |row|
      store.merge!(
        row.fetch(:symbol).downcase => row.fetch(:security_name),
      )
    end
  end

  def lookup(stock_symbol)
    store.fetch(stock_symbol, 'Unknown Company')
  end
end
