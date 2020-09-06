RSpec.configure do |config|

  config.before do
    stub_const('StockAnalyzer::DISABLE_PARALLEL', true)
  end

end
