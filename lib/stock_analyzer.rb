require 'active_support/all'
require 'csv'
require 'date'
require 'parallel'
require 'terminal-table'

require_relative 'stock_analyzer/stock_quote'
require_relative 'stock_analyzer/single_trade_profit_analyzer'
require_relative 'stock_analyzer/maximum_profit_analyzer'
require_relative 'stock_analyzer/normalizer'
require_relative 'stock_analyzer/helpers'

class StockAnalyzer

  ROOT = File.expand_path('..', __dir__)

  def self.available_stocks
    entries = Dir.glob(File.join(ROOT, 'db', '*.txt'))
    Parallel.map(entries) do |file|
      if File.foreach(file).count > 3 && !file.end_with?('.normalized.txt') && !file.start_with?('test')
        Pathname(file).basename.to_s[/\A([^\.]+)/, 1]
      end
    end.compact
  end

  def self.normalized_file(stock_name, region)
    File.join(ROOT, 'db', "#{stock_name}.#{region}.normalized.txt")
  end

  def self.original_file(stock_name, region)
    File.join(ROOT, 'db', "#{stock_name}.#{region}.txt")
  end

  def self.print_ranking(title:, stock_names:, start_date:, end_date:, region: 'us', analytics_method:, limit: 100)
    analytics = Parallel.map(stock_names) do |stock_name|
      new(stock_name, start_date: start_date, end_date: end_date, region: region).public_send(analytics_method)
    end

    analytics = analytics.reduce(&:merge)
    analytics = analytics.sort_by { |_key, value| -value }
    analytics = analytics.map.with_index(1) { |analytic, index| analytic.unshift("#{index}.") }

    puts Terminal::Table.new(
      title: title,
      headings: ['Rank', 'Stock name', 'Profit'],
      rows: analytics.first(limit),
    )
  end

  attr_accessor :stock_name, :start_date, :end_date, :region

  def initialize(stock_name, start_date:, end_date:, region: 'us')
    self.stock_name = stock_name
    self.start_date = start_date
    self.end_date = end_date
    self.region = region
  end

  def analyze_single_trade_profit
    SingleTradeProfitAnalyzer.new(start_date, end_date, stock_name, stock_quotes).analyze
  end

  def analyze_maximum_profit
    MaximumProfitAnalyzer.new(start_date, end_date, stock_name, stock_quotes).analyze
  end

  private

  def stock_quotes
    @stock_quotes ||= begin
      normalized_file = self.class.normalized_file(stock_name, region)
      file = File.exist?(normalized_file) ? normalized_file : self.class.original_file(stock_name, region)

      raw_data = CSV.read(
        file,
        headers: true,
        header_converters: [:downcase, :symbol],
      )

      raw_data.map do |row|
        StockQuote.parse(
          date: row.fetch(:date),
          open: row.fetch(:open),
        )
      end
    end
  end

end
