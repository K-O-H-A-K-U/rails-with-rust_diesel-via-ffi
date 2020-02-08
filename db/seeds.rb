# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  puts 'start'
  start_time = Time.zone.now

  100.times { User.create(name: Faker::Name.name) }

  somethings = []
  (1..5_000_000).each do |t|
    somethings << {
      user_id: rand((1..User.all.size)),
      int: rand(10_000),
      str: Faker::Lorem.word,
      date: Faker::Date.birthday(min_age: 18, max_age: 80),
      nest: 0,
      created_at: Time.zone.now,
      updated_at: Time.zone.now
    }
    next unless (t % 10_000).zero?

    puts "#{t} finished."
    Something.insert_all(somethings)
    somethings = []
  end
  puts "all finished #{Time.zone.now - start_time}"
rescue StandardError => e
  warn e
  raise ActiveRecord::Rollback
end
