RSpec.configure do |config|

  config.before do
    stub_const('StockAnalyzer::DATABASE_DIRECTORY', StockAnalyzer::ROOT.join('spec', 'fixtures'))
  end

end
