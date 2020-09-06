describe SingleTradeProfitAnalyzer do

  describe '#analyze' do
    let(:stock_1) { StockQuote.new(date: nil, open: 2) }
    let(:stock_2) { StockQuote.new(date: nil, open: 4) }
    let(:stock_3) { StockQuote.new(date: nil, open: 8) }
    let(:stock_4) { StockQuote.new(date: nil, open: 1) }

    def analyze(*stock_quotes)
      described_class.new(stock_symbol: 'stock name', stock_quotes: stock_quotes).analyze
    end

    it 'returns the profit between the opening price at the start date and the opening price of the end date', aggregate_failures: true do
      expect(analyze).to eq({ 'stock name' => BigDecimal('0') })
      expect(analyze(stock_1)).to eq({ 'stock name' => BigDecimal('0') })
      expect(analyze(stock_1, stock_2)).to eq({ 'stock name' => BigDecimal('2') })
      expect(analyze(stock_1, stock_2, stock_3)).to eq({ 'stock name' => BigDecimal('6') })
      expect(analyze(stock_1, stock_2, stock_3, stock_4)).to eq({ 'stock name' => BigDecimal('-1') })
      expect(analyze(stock_1, stock_4)).to eq({ 'stock name' => BigDecimal('-1') })
    end
  end

end
