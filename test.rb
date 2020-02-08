# frozen_string_literal: true

require 'benchmark'
require 'csv'

class Spec
  def self.ar_eager_each
    arr = []
    Something.eager_load(:user).find_each(batch_size: 10_000) do |something|
      arr.push something.user.name
    end
  end

  def self.sequel_unsafe_eager_each
    arr = []
    SomethingSequel.dataset.extension(:pagination).each_page(10_000) do |rows|
      rows.eager_graph(:user).each do |something|
        arr.push something.user.name
      end
    end
  end

  def self.sequel_safe_eager_each
    arr = []
    SomethingSequel.eager_graph(:user).paged_each(rows_per_fetch: 10_000) do |something|
      arr.push something.user.name
    end
  end

  def self.ar_fetch_50000
    somethings = Something.order(:id).limit(50_000)
    somethings.each(&:date)
  end

  def self.sql_fetch_50000
    somethings = SomethingSequel.order(:id).limit(50_000).to_a
    somethings.each(&:date)
  end

  def self.ar_fetch_50000_eager
    somethings = Something.eager_load(:user).limit(50_000).order(:id)
    somethings.each { |something| something.user.name }
  end

  def self.sql_fetch_50000_eager
    somethings = SomethingSequel.limit(50_000).eager_graph(:user).order(:id)
    somethings.each { |something| something.user.name }
  end

  def self.eager_each_benchmark
    Benchmark.bm do |x|
      x.report('ar_eager_each') { ar_eager_each }
      x.report('sequel_unsafe_eager_each') { sequel_unsafe_eager_each }
      x.report('sequel_safe_eager_each') { sequel_safe_eager_each }
    end
  end

  def self.fetch_benchmark
    Benchmark.bm do |x|
      x.report('ar_fetch') { ar_fetch_50000 }
      x.report('sql_fetch') { sql_fetch_50000 }
    end
  end

  def self.eager_fetch_benchmark
    Benchmark.bm do |x|
      x.report('ar_fetch_eager') { ar_fetch_50000_eager }
      x.report('sql_fetch_eager') { sql_fetch_50000_eager }
    end
  end

  def self.ar_write_csv
    CSV.open('csv/test.csv', 'wb') do |csv|
      Something.preload(:user).limit(5_000_000).each_slice(10_000) do |somethings|
        somethings.each do |something|
          csv << [something.user.name, something.str]
        end
      end
    end
  end

  def self.sql_write_csv
    CSV.open('csv/test.csv', 'wb') do |csv|
      SomethingSequel.eager_graph(:user).limit(500_000).paged_each(rows_per_fetch: 10_000) do |something|
        csv << [something.user.name, something.str]
      end
    end
  end
end
