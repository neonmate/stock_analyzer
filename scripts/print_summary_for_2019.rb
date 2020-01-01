require_relative '../lib/stock_analyzer'

config = {
  start_date: Date.parse('2019-01-01'),
  end_date: Date.parse('2019-12-31'),
  normalize: true,
  limit: 100,
  analyze_maximum_profit: true,
  analyze_single_trade_profit: true,
}

start_time = Time.now

puts "> Reading stocks"
stocks = StockAnalyzer.available_stocks.first(3)
puts "> Finished in #{Helpers.passed_time(start_time)}"

puts

if config.fetch(:normalize)
  puts "> Normalize #{stocks.size} stocks"

  stocks.each do |stock_name|
    Normalizer.new(
      start_date: config.fetch(:start_date),
      end_date: config.fetch(:end_date),
      stock_name: stock_name,
    ).normalize
  end

  puts "> Finished in #{Helpers.passed_time(start_time)}"
end

puts

if config.fetch(:analyze_single_trade_profit)
  puts "> Analyze single trade profit for #{stocks.size} stocks"

  StockAnalyzer.print_ranking(
    title: "Single trade profit from #{config.fetch(:start_date)} to #{config.fetch(:end_date)}",
    stock_names: stocks,
    start_date: config.fetch(:start_date),
    end_date: config.fetch(:end_date),
    analytics_method: :analyze_single_trade_profit,
    limit: config.fetch(:limit),
  )
  puts "> Finished in #{Helpers.passed_time(start_time)}"
end

puts

if config.fetch(:analyze_maximum_profit)
  puts "> Analyze maximum profit for #{stocks.size} stocks"

  StockAnalyzer.print_ranking(
    title: "Maximum profit from #{config.fetch(:start_date)} to #{config.fetch(:end_date)}",
    stock_names: stocks,
    start_date: config.fetch(:start_date),
    end_date: config.fetch(:end_date),
    analytics_method: :analyze_maximum_profit,
    limit: config.fetch(:limit),
  )
  puts "> Finished in #{Helpers.passed_time(start_time)}"
end

puts
puts '> All operations finished.'
