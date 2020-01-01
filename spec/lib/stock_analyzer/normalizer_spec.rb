describe Normalizer do
  describe '.normalize' do
    let(:start_date) { Date.parse('2019-11-12') }
    let(:end_date) { Date.parse('2019-11-19') }

    it 'fills in missing open values' do
      original_file = File.open(StockAnalyzer.original_file('test3', 'us'))
      normalized_file = Tempfile.new(['normalized', '.txt'])

      begin
        described_class.new(
          start_date: start_date,
          end_date: end_date,
          stock_name: 'test3',
          output: normalized_file,
        ).normalize

        expect(original_file.read).to eq(<<~TEXT)
          Date,Open,High,Low,Close,Volume,OpenInt
          20191112,,30.67,29.4,29.52,8663841,0
          20191113,29.03,29.155,28.565,28.66,7179903,0
          20191114,,28.9,28.46,28.77,4393223,0
          20191115,28.95,29.2,28.8,28.86,4551993,0
          20191118,28.64,28.89,28.2787,28.6,5368970,0
          20191119,,29.38,28.73,29.29,5966379,0
        TEXT

        expect(normalized_file.read).to eq(<<~TEXT)
          Date,Open,High,Low,Close,Volume,OpenInt
          20191112,29.03,,,,,
          20191113,29.03,,,,,
          20191114,28.95,,,,,
          20191115,28.95,,,,,
          20191116,28.95,,,,,
          20191117,28.95,,,,,
          20191118,28.64,,,,,
          20191119,28.64,,,,,
        TEXT
      ensure
        normalized_file.close
        normalized_file.unlink
      end
    end

    it 'appends and prepends the entries before and after the range' do
      original_file = File.open(StockAnalyzer.original_file('test3', 'us'))
      normalized_file = Tempfile.new(['normalized', '.txt'])

      begin
        described_class.new(
          start_date: start_date - 2.days,
          end_date: end_date + 2.days,
          stock_name: 'test3',
          output: normalized_file,
        ).normalize

        expect(original_file.read).to eq(<<~TEXT)
          Date,Open,High,Low,Close,Volume,OpenInt
          20191112,,30.67,29.4,29.52,8663841,0
          20191113,29.03,29.155,28.565,28.66,7179903,0
          20191114,,28.9,28.46,28.77,4393223,0
          20191115,28.95,29.2,28.8,28.86,4551993,0
          20191118,28.64,28.89,28.2787,28.6,5368970,0
          20191119,,29.38,28.73,29.29,5966379,0
        TEXT

        expect(normalized_file.read).to eq(<<~TEXT)
          Date,Open,High,Low,Close,Volume,OpenInt
          20191110,29.03,,,,,
          20191111,29.03,,,,,
          20191112,29.03,,,,,
          20191113,29.03,,,,,
          20191114,28.95,,,,,
          20191115,28.95,,,,,
          20191116,28.95,,,,,
          20191117,28.95,,,,,
          20191118,28.64,,,,,
          20191119,28.64,,,,,
          20191120,28.64,,,,,
          20191121,28.64,,,,,
        TEXT
      ensure
        normalized_file.close
        normalized_file.unlink
      end
    end
  end
end
