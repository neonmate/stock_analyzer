require 'active_support/all'
require 'csv'
require 'date'
require 'parallel'
require 'terminal-table'
require 'pathname'

require_relative 'stock_analyzer/stock_quote'
require_relative 'stock_analyzer/single_trade_profit_analyzer'
require_relative 'stock_analyzer/maximum_profit_analyzer'
require_relative 'stock_analyzer/helpers'
require_relative 'stock_analyzer/humanized_stock_name'

class StockAnalyzer

  ROOT = Pathname.new(File.expand_path('..', __dir__)).freeze
  DATABASE_DIRECTORY = StockAnalyzer::ROOT.join('db').freeze
  DISABLE_PARALLEL = false

  def self.parallel_options
    options = {}
    options[:in_processes] = 1 if DISABLE_PARALLEL

    options
  end

  def self.available_stocks
    Dir.glob(DATABASE_DIRECTORY.join('*.txt')).map do |file|
      File.basename(file)[/\A([^\.]+)/, 1]
    end
  end

  def self.database_file(stock_symbol, region)
    DATABASE_DIRECTORY.join("#{stock_symbol}.#{region}.txt")
  end

  def self.print_ranking(title:, stock_symbols:, start_date:, end_date:, region: 'us', analytics_method:, limit: 100)
    analytics = Parallel.map(stock_symbols, **parallel_options) do |stock_symbol|
      new(stock_symbol, start_date: start_date, end_date: end_date, region: region).public_send(analytics_method)
    end

    analytics = analytics.reduce(&:merge)
    analytics = analytics.sort_by { |_key, value| -value }
    analytics = analytics.map.with_index(1) do |(stock_symbol, profit), index|
      [
        "#{index}.",
        stock_symbol,
        HumanizedStockName.instance.lookup(stock_symbol),
        profit,
      ]
    end

    puts Terminal::Table.new(
      title: title,
      headings: ['Rank', 'Symbol', 'Name', 'Profit'],
      rows: analytics.first(limit),
    )
  end

  attr_accessor :stock_symbol, :start_date, :end_date, :region

  def initialize(stock_symbol, start_date:, end_date:, region: 'us')
    self.stock_symbol = stock_symbol
    self.start_date = start_date
    self.end_date = end_date
    self.region = region
  end

  def analyze_single_trade_profit
    SingleTradeProfitAnalyzer.new(stock_symbol: stock_symbol, stock_quotes: stock_quotes).analyze
  end

  def analyze_maximum_profit
    MaximumProfitAnalyzer.new(stock_symbol: stock_symbol, stock_quotes: stock_quotes).analyze
  end

  private

  def stock_quotes
    @stock_quotes ||= begin
      raw_stock_quotes = CSV.read(
        self.class.database_file(stock_symbol, region),
        headers: true,
        header_converters: [:downcase, :symbol],
      )

      stock_quotes = []
      raw_stock_quotes.each do |raw_stock_quote|
        stock_quote = StockQuote.parse(
          date: raw_stock_quote.fetch(:date),
          open: raw_stock_quote.fetch(:open),
        )

        if stock_quote.relevant?(start_date, end_date)
          stock_quotes << stock_quote
        end
      end

      stock_quotes.sort_by(&:date)
    end
  end

end
