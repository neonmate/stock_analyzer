describe StockAnalyzer do

  describe '.print' do
    let(:start_date) { Date.parse('2019-11-08') }
    let(:end_date) { Date.parse('2019-11-25') }

    it 'prints the stock analytics as table' do
      options = { start_date: start_date, end_date: end_date }
      expect { described_class.print(['test', 'test2'], **options) }.to output(<<~TEXT).to_stdout
        +-----------------+----------------+----------------+
        | Single trade profit from 2019-11-08 to 2019-11-08 |
        +-----------------+----------------+----------------+
        | Rank            | Stock name     | Profit         |
        +-----------------+----------------+----------------+
        | 1.              | test2          | 29.28          |
        | 2.              | test           | -1.92          |
        +-----------------+----------------+----------------+


        +---------------+---------------+--------------+
        | Maximum profit from 2019-11-08 to 2019-11-08 |
        +---------------+---------------+--------------+
        | Rank          | Stock name    | Profit       |
        +---------------+---------------+--------------+
        | 1.            | test2         | 32.54        |
        | 2.            | test          | 1.34         |
        +---------------+---------------+--------------+
      TEXT
    end
  end

  describe '#analyze_single_trade_profit' do
    let(:start_date) { Date.parse('2019-11-08') }
    let(:end_date) { Date.parse('2019-11-25') }

    it 'returns the profits for buying at the start date and selling at the end date' do
      analyzer = StockAnalyzer.new('test', start_date: start_date, end_date: end_date)

      expect(analyzer.analyze_single_trade_profit).to eq('test' => BigDecimal('-0.192e1'))
    end
  end

  describe '#analyze_maximum_profit' do
    let(:start_date) { Date.parse('2019-11-08') }
    let(:end_date) { Date.parse('2019-11-25') }

    it 'returns the maximum profit you can reach for unlimited trades between the start and end date' do
      analyzer = StockAnalyzer.new('test', start_date: start_date, end_date: end_date)

      expect(analyzer.analyze_maximum_profit).to eq('test' => BigDecimal('0.134e1'))
    end
  end

end
