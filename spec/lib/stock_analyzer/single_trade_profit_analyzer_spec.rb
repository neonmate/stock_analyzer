describe SingleTradeProfitAnalyzer do

  describe '#analyze' do
    let(:stock_1) { StockQuote.new(date: Date.parse('2019-01-01'), open: 2) }
    let(:stock_2) { StockQuote.new(date: Date.parse('2019-01-02'), open: 4) }
    let(:stock_3) { StockQuote.new(date: Date.parse('2019-01-03'), open: 8) }
    let(:stock_4) { StockQuote.new(date: Date.parse('2019-01-04'), open: 1) }
    let(:stocks) { [stock_1, stock_2, stock_3, stock_4] }

    def analyze(start_date, end_date)
      described_class.new(Date.parse(start_date), Date.parse(end_date), 'stock name', stocks).analyze
    end

    it 'returns the profit between the opening price at the start date and the opening price of the end date', aggregate_failures: true do
      expect(analyze('2019-01-01', '2019-01-02')).to eq({ 'stock name' => BigDecimal('2') })
      expect(analyze('2019-01-01', '2019-01-03')).to eq({ 'stock name' => BigDecimal('6') })
      expect(analyze('2019-01-01', '2019-01-04')).to eq({ 'stock name' => BigDecimal('-1') })
    end
  end

end
