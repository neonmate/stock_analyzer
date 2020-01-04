class SymbolLookup
  include Singleton

  def self.lookup_database
    File.join(StockAnalyzer::ROOT, 'db', 'nasdaqlisted.csv')
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

  def lookup(symbol)
    store.fetch(symbol, 'Unknown Company')
  end
end
