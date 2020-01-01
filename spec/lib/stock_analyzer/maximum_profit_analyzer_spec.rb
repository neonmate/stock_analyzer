describe MaximumProfitAnalyzer do

  describe '#analyze' do
    let(:stock_1) { StockQuote.new(date: Date.parse('2019-01-01'), open: 2) }
    let(:stock_2) { StockQuote.new(date: Date.parse('2019-01-02'), open: 4) }
    let(:stock_3) { StockQuote.new(date: Date.parse('2019-01-03'), open: 8) }
    let(:stock_4) { StockQuote.new(date: Date.parse('2019-01-04'), open: 1) }
    let(:stock_5) { StockQuote.new(date: Date.parse('2019-01-05'), open: 9) }
    let(:stock_6) { StockQuote.new(date: Date.parse('2019-01-06'), open: 8) }

    let(:stocks) { [stock_1, stock_2, stock_3, stock_4, stock_5, stock_6] }

    def analyze(start_date, end_date)
      described_class.new(Date.parse(start_date), Date.parse(end_date), 'stock name', stocks).analyze
    end

    it 'returns the maximum profit of the opening price for unlimited trades between two dates', aggregate_failures: true do
      expect(analyze('2019-01-01', '2019-01-02')).to eq({ 'stock name' => BigDecimal('2') })
      expect(analyze('2019-01-01', '2019-01-03')).to eq({ 'stock name' => BigDecimal('6') })
      expect(analyze('2019-01-01', '2019-01-04')).to eq({ 'stock name' => BigDecimal('6') })
      expect(analyze('2019-01-01', '2019-01-05')).to eq({ 'stock name' => BigDecimal('14') })
      expect(analyze('2019-01-01', '2019-01-06')).to eq({ 'stock name' => BigDecimal('14') })
    end
  end

end
