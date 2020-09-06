# Stock analyzer

This program can analyze NASDAQ's historical stock data in terms of profit:

* Stocks ordered by single trade profit (single purchase and sell)

  Example:

  | Day 1 | Day 2 | Day 3 | Day 4 |
  |-------|-------|-------|-------|
  | 2     | 4     | 8     | 1     |

  They single trade profit between day 1 and day 4 is `1 - 2 = -1`.
  Between day 1 and day 2 it is `8 - 2 = 6`.

* Stocks ordered by maximum profit (multiple purchases and sells)

  Example:

  | Day 1 | Day 2 | Day 3 | Day 4 | Day 5 | Day 6 |
  |-------|-------|-------|-------|-------|-------|
  | 2     | 4     | 8     | 1     | 9     | 8     |

  The maximum profit between day 1 and day 6 is `(8 - 2) + (9 - 1) = 14` (Buying on day 1, selling on day 3, buying on day 4 and selling on day 5).
  Between day 1 and day 4 it is `8 - 2 = 6` (Buying on day 1, selling on day 3).

## Usage

* Install Ruby e.g. `rbenv install 2.7.0`
* Install bundler `gem install bundler -v '~>2'`
* Bundle the project `bundle install`

* [Download](https://stooq.com/db/h/) a free dump of historical stock data for "US (daily)". Extract the ZIP and move all files
  from the folder "nasdaq stocks" to the `db` folder in the project, so that folder contains the files `aacg.us.txt`, `aal.us.txt` and so on.
* Download the `nasdaqlisted.txt` from ftp://ftp.nasdaqtrader.com/symboldirectory, rename it to `nasdaqlisted.csv` and
  place it in the `db/` folder, too.

Now you can analyze a stock over a given period:

```
bin/runner "puts StockAnalyzer.new('amzn', start_date: Date.parse('2020-01-01'), end_date: Date.parse('2020-09-01')).analyze_single_trade_profit"

{"amzn"=>0.145299e4}
```

```
bin/runner "puts StockAnalyzer.new('amzn', start_date: Date.parse('2020-01-01'), end_date: Date.parse('2020-09-01')).analyze_maximum_profit"

{"amzn"=>0.4634536e4}
```

Or compare a list of stocks over a given period:

```
bin/runner "StockAnalyzer.print_ranking(title: 'My single trade comparision for Amamzon and AMD', stock_symbols: ['amzn', 'amd'], start_date: Date.parse('2020-01-01'), end_date: Date.parse('2020-09-01'), analytics_method: :analyze_single_trade_profit)"

+------+--------+---------------------------------------------+---------+
|            My single trade comparision for Amamzon and AMD            |
+------+--------+---------------------------------------------+---------+
| Rank | Symbol | Name                                        | Profit  |
+------+--------+---------------------------------------------+---------+
| 1.   | amzn   | Amazon.com, Inc. - Common Stock             | 1452.99 |
| 2.   | amd    | Advanced Micro Devices, Inc. - Common Stock | 38.29   |
+------+--------+---------------------------------------------+---------+
```

```
bin/runner "StockAnalyzer.print_ranking(title: 'My maximum profit comparision for Amamzon and AMD', stock_symbols: ['amzn', 'amd'], start_date: Date.parse('2020-01-01'), end_date: Date.parse('2020-09-01'), analytics_method: :analyze_maximum_profit)"

+------+--------+---------------------------------------------+----------+
|           My maximum profit comparision for Amamzon and AMD            |
+------+--------+---------------------------------------------+----------+
| Rank | Symbol | Name                                        | Profit   |
+------+--------+---------------------------------------------+----------+
| 1.   | amzn   | Amazon.com, Inc. - Common Stock             | 4634.536 |
| 2.   | amd    | Advanced Micro Devices, Inc. - Common Stock | 154.5521 |
+------+--------+---------------------------------------------+----------+
```

Or run `ruby scripts/print_summary` to get a summary of all stocks available in the NASDAQ stock index.

# Links

* [2020 analysis (until August)](analysis/2020.md)
* [2019 analysis](analysis/2019.md)
* [2018 analysis](analysis/2018.md)
* [2017 analysis](analysis/2017.md)

# Tests

Execute `rake` to run all RSpec tests.
