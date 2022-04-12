# frozen_string_literal: true

class Statistics
  def initialize
    @statistics = CodeBreaker.stats
  end

  def call
    return [] if @statistics.nil?

    statistics_sort = @statistics.sort_by { |i| [i[1][:attempts], i[1][:attempt_used]] }
    statistics_without_attempts = statistics_sort.each { |i| i.delete_at(4) }
    rows(statistics_without_attempts)
  end

  def rows(hash)
    rows = []
    hash.each do |breaker|
      row = []
      row << (hash.find_index(breaker) + 1)
      row << breaker.first.to_s
      breaker.last.each { |param| row << param.last }
      rows << row
    end
    rows
  end
end
