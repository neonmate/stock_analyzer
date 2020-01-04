# Stock analyzer

This program can analyze NASDAQ's historical stock data in terms of profit:

* Stocks ordered by maximum theoretical profit (multiple purchases and sells)
* Stocks ordered by maximum profit from January 1st to December 31th (single purchase and sell)

## Usage

* Install Ruby e.g. `rbenv install 2.7.0`
* Install bundler `gem install bundler -v '~>2'`
* Bundle the project `bundle install`

* [Download](https://stooq.com/db/h/) a free dump of historical stock data for the daily US NASDAQ, so that the `db/`
folder contains the extracted files `aacg.us.txt`, `aal.us.txt` and so on.
* [Download](ftp://ftp.nasdaqtrader.com/symboldirectory) the `nasdaqlisted.txt`, rename it to `nasdaqlisted.csv` and
place it in the `db/` folder, too.

Now you can analyze a list of stocks over a given period:

```
bin/runner "StockAnalyzer.print(['amzn'], start_date: Date.parse('2019-01-01'), end_date: Date.parse('2019-12-31'))""
```

Note: The historical stock data from Stooq has missing days, so the results will never be 100% accurate. The scripts
try to normalize the missing values to avoid a crashing of the program.

## Example output

```
ruby scripts/print_summary_for_2019.rb

> Reading stocks
> Finished in 10 seconds 358 milliseconds

> Normalize 3 stocks
> Finished in 10 seconds 978 milliseconds

> Analyze single trade profit for 3 stocks
+-----------------+----------------+----------------+
| Single trade profit from 2019-01-01 to 2019-12-31 |
+-----------------+----------------+----------------+
| Rank            | Stock name     | Profit         |
+-----------------+----------------+----------------+
| 1.              | flic           | 5.735          |
| 2.              | opnt           | 0.97           |
| 3.              | grvy           | -4.91          |
+-----------------+----------------+----------------+
> Finished in 11 seconds 328 milliseconds

> Analyze maximum profit for 3 stocks
+---------------+---------------+--------------+
| Maximum profit from 2019-01-01 to 2019-12-31 |
+---------------+---------------+--------------+
| Rank          | Stock name    | Profit       |
+---------------+---------------+--------------+
| 1.            | grvy          | 207.7838     |
| 2.            | opnt          | 40.419       |
| 3.            | flic          | 30.383       |
+---------------+---------------+--------------+
> Finished in 12 seconds 596 milliseconds
> All operations finished.
```

# Tests

The test will use the imaginary `db/test*.us.txt` historical data dumps. Execute `rake` to run all RSpec tests.
