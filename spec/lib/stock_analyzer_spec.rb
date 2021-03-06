describe StockAnalyzer do

  describe '.print_ranking' do
    let(:start_date) { Date.parse('2019-11-08') }
    let(:end_date) { Date.parse('2019-11-25') }
    let(:stock_symbols) { ['test1', 'test2'] }

    it 'allows to print the single trade profit as table' do
      arguments = {
        title: 'Single trade profit',
        stock_symbols: stock_symbols,
        start_date: start_date,
        end_date: end_date,
        analytics_method: :analyze_single_trade_profit,
      }

      expect { described_class.print_ranking(**arguments) }.to output(<<~TEXT).to_stdout
        +------+--------+----------------+--------+
        |           Single trade profit           |
        +------+--------+----------------+--------+
        | Rank | Symbol | Name           | Profit |
        +------+--------+----------------+--------+
        | 1.   | test2  | Test Company 2 | 3.44   |
        | 2.   | test1  | Test Company 1 | -34.64 |
        +------+--------+----------------+--------+
      TEXT
    end

    it 'allows to print the maximum profit as table' do
      arguments = {
        title: 'Maximum profit trade profit',
        stock_symbols: stock_symbols,
        start_date: start_date,
        end_date: end_date,
        analytics_method: :analyze_maximum_profit,
      }

      expect { described_class.print_ranking(**arguments) }.to output(<<~TEXT).to_stdout
        +------+--------+----------------+--------+
        |       Maximum profit trade profit       |
        +------+--------+----------------+--------+
        | Rank | Symbol | Name           | Profit |
        +------+--------+----------------+--------+
        | 1.   | test1  | Test Company 1 | 41.54  |
        | 2.   | test2  | Test Company 2 | 5.43   |
        +------+--------+----------------+--------+
      TEXT
    end
  end

  describe '#analyze_single_trade_profit' do
    let(:start_date) { Date.parse('2019-11-08') }
    let(:end_date) { Date.parse('2019-11-25') }

    it 'returns the profits for buying at the start date and selling at the end date' do
      analyzer = StockAnalyzer.new('test1', start_date: start_date, end_date: end_date)

      expect(analyzer.analyze_single_trade_profit).to eq('test1' => BigDecimal('-34.64'))
    end
  end

  describe '#analyze_maximum_profit' do
    let(:start_date) { Date.parse('2019-11-08') }
    let(:end_date) { Date.parse('2019-11-25') }

    it 'returns the maximum profit you can reach for unlimited trades between the start and end date' do
      analyzer = StockAnalyzer.new('test1', start_date: start_date, end_date: end_date)

      expect(analyzer.analyze_maximum_profit).to eq('test1' => BigDecimal('41.54'))
    end
  end

end
