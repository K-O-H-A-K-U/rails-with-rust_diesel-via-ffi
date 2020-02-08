# frozen_string_literal: true

DB.transaction do
  puts 'start'
  start_time = Time.zone.now

  100.times { UserSequel.create(name: Faker::Name.name) }

  somethings = []
  (1..5_000_000).each do |t|
    somethings << {
      user_id: rand((1..UserSequel.all.size)),
      int: rand(10_000),
      str: Faker::Lorem.word,
      date: Faker::Date.birthday(min_age: 18, max_age: 80),
      nest: 0,
      created_at: Time.zone.now,
      updated_at: Time.zone.now
    }
    next unless (t % 10_000).zero?

    puts "#{t} finished."
    SomethingSequel.multi_insert(somethings)
    somethings = []
  end
  puts "all finished #{Time.zone.now - start_time}"
rescue StandardError => e
  warn e
  raise Sequel::Rollback
end
