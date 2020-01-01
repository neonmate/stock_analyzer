module Helpers

  module_function

  def passed_time(start_time)
    milliseconds = ((Time.now.to_f - start_time.to_f) * 1000).to_i
    human_time(milliseconds)
  end

  def human_time(milliseconds)
    parts = [[1000, :milliseconds], [60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].each_with_object([]) do |(unit_size, name), array|
      if milliseconds > 0
        milliseconds, rest = milliseconds.divmod(unit_size)

        array.unshift("#{rest.to_i} #{name}") unless rest.to_i == 0
      end
    end

    parts.join(' ')
  end

end
