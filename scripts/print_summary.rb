#!/usr/bin/env ruby

# This summary creates a comparison of all stocks available in the NASDAQ stock index
#
# Example output:
#
# > Reading stocks
# > Finished in 3 seconds 641 milliseconds
#
# > Normalize 3423 stocks
# > Finished in 10 minutes 507 milliseconds
#
# > Analyze single trade profit for 3423 stocks
# +------+--------+-------------------------------------------------------------------------------------+---------+
# |                               Single trade profit from 2020-01-01 to 2020-12-31                               |
# +------+--------+-------------------------------------------------------------------------------------+---------+
# | Rank | Symbol | Name                                                                                | Profit  |
# +------+--------+-------------------------------------------------------------------------------------+---------+
# | 1.   | tsla   | Tesla, Inc.  - Common Stock                                                         | 1569.89 |
# | 2.   | amzn   | Amazon.com, Inc. - Common Stock                                                     | 1452.99 |
# | 3.   | meli   | MercadoLibre, Inc. - Common Stock                                                   | 627.59  |
# | 4.   | nvda   | NVIDIA Corporation - Common Stock                                                   | 274.58  |
# | 5.   | csgp   | CoStar Group, Inc. - Common Stock                                                   | 253.62  |
# | 6.   | goog   | Alphabet Inc. - Class C Capital Stock                                               | 251.96  |
# | 7.   | googl  | Alphabet Inc. - Class A Common Stock                                                | 244.31  |
# | 8.   | regn   | Regeneron Pharmaceuticals, Inc. - Common Stock                                      | 222.87  |
# | 9.   | ttd    | The Trade Desk, Inc. - Class A Common Stock                                         | 214.35  |
# | 10.  | zm     | Zoom Video Communications, Inc. - Class A Common Stock                              | 212.62  |
# ...
# +------+--------+-------------------------------------------------------------------------------------+---------+
# > Finished in 12 minutes 17 seconds 419 milliseconds
#
# > Analyze maximum profit for 3423 stocks
# +------+--------+----------------------------------------------------------------------------------+-----------+
# |                                 Maximum profit from 2020-01-01 to 2020-12-31                                 |
# +------+--------+----------------------------------------------------------------------------------+-----------+
# | Rank | Symbol | Name                                                                             | Profit    |
# +------+--------+----------------------------------------------------------------------------------+-----------+
# | 1.   | amzn   | Amazon.com, Inc. - Common Stock                                                  | 4634.536  |
# | 2.   | tsla   | Tesla, Inc.  - Common Stock                                                      | 4254.8    |
# | 3.   | bkng   | Booking Holdings Inc. - Common Stock                                             | 3051.01   |
# | 4.   | meli   | MercadoLibre, Inc. - Common Stock                                                | 2100.05   |
# | 5.   | goog   | Alphabet Inc. - Class C Capital Stock                                            | 1981.64   |
# | 6.   | googl  | Alphabet Inc. - Class A Common Stock                                             | 1972.5755 |
# | 7.   | avgop  | Broadcom Inc. - 8.00% Mandatory Convertible Preferred Stock, Series A            | 1497.3671 |
# | 8.   | csgp   | CoStar Group, Inc. - Common Stock                                                | 1376.03   |
# | 9.   | eqix   | Equinix, Inc. - Common Stock                                                     | 1118.0    |
# | 10.  | atri   | Atrion Corporation - Common Stock                                                | 1093.0032 |
# ...
# +------+--------+----------------------------------------------------------------------------------+-----------+
# > Finished in 25 minutes 10 seconds 318 milliseconds
#
# > All operations finished.

require_relative '../lib/stock_analyzer'

config = {
  start_date: Date.parse('2020-01-01'),
  end_date: Date.parse('2020-12-31'),
  limit: 100,
  analyze_single_trade_profit: true,
  analyze_maximum_profit: true,
}

start_time = Time.now

puts '> Reading stocks'
stocks = StockAnalyzer.available_stocks
puts "> Finished in #{Helpers.passed_time(start_time)}"

puts

if config.fetch(:analyze_single_trade_profit)
  puts "> Analyze single trade profit for #{stocks.size} stocks"

  StockAnalyzer.print_ranking(
    title: "Single trade profit from #{config.fetch(:start_date)} to #{config.fetch(:end_date)}",
    stock_symbols: stocks,
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
    stock_symbols: stocks,
    start_date: config.fetch(:start_date),
    end_date: config.fetch(:end_date),
    analytics_method: :analyze_maximum_profit,
    limit: config.fetch(:limit),
  )
  puts "> Finished in #{Helpers.passed_time(start_time)}"
end

puts
puts '> All operations finished.'
