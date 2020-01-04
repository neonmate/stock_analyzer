class Normalizer

  attr_accessor :start_date, :end_date, :stock_symbol, :region, :normalized_file, :original_file

  def initialize(start_date:, end_date:, stock_symbol:, region: 'us', output: nil)
    self.start_date = start_date
    self.end_date = end_date
    self.stock_symbol = stock_symbol
    self.region = region
    self.normalized_file = output.present? ? output : StockAnalyzer.normalized_file(stock_symbol, region)
    self.original_file = StockAnalyzer.original_file(stock_symbol, region)
  end

  def normalize
    stock_quotes = normalize_existing_rows

    missing_head_stock_quotes(stock_quotes).reverse_each do |stock_quote|
      stock_quotes.unshift(stock_quote)
    end

    missing_tail_stock_quotes(stock_quotes).each do |stock_quote|
      stock_quotes.append(stock_quote)
    end

    write_normalized_file(stock_quotes)
  end

  private

  def normalize_existing_rows
    raw_input = read_original_file
    stock_quotes = []

    raw_input.each_cons(2) do |current_row, next_row|
      open = if current_row.fetch(:open).present?
        current_row.fetch(:open)
      elsif next_row.blank?
        next # We drop the last line
      elsif next_row.fetch(:open).present?
        next_row.fetch(:open)
      else
        raise ArgumentError, "Two succeeding rows doe not contain an open value, please fix the row #{next_row}"
      end

      stock_quotes << StockQuote.parse(
        date: current_row.fetch(:date),
        open: open,
      )

      # Filling in missing dates between two rows
      (Date.parse(current_row.fetch(:date)) + 1.day...Date.parse(next_row.fetch(:date))).each do |date|
        stock_quotes << StockQuote.new(
          date: date,
          open: BigDecimal(open),
        )
      end
    end

    stock_quotes
  end

  def read_original_file
    CSV.read(
      original_file,
      headers: true,
      header_converters: [:downcase, :symbol],
    )
  end

  def missing_head_stock_quotes(stock_quotes)
    stock_quotes_beginner = stock_quotes.first

    (start_date...stock_quotes_beginner.date).map do |date|
      StockQuote.new(
        date: date,
        open: stock_quotes_beginner.open,
      )
    end
  end

  def missing_tail_stock_quotes(stock_quotes)
    stock_quotes_finisher = stock_quotes.last

    (stock_quotes_finisher.date + 1.day..end_date).map do |date|
      StockQuote.new(
        date: date,
        open: stock_quotes_finisher.open,
      )
    end
  end

  def write_normalized_file(stock_quotes)
    headers = File.open(original_file, &:readline).chomp.split(',')

    CSV.open(normalized_file, 'w', write_headers: true, headers: headers) do |csv|
      stock_quotes.each do |stock_quote|
        csv << [stock_quote.date.strftime('%Y%m%d'), stock_quote.open, nil, nil, nil, nil, nil]
      end
    end
  end

end
