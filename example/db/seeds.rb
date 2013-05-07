def log(message, &block)
  puts "*** #{message.titleize}"
  time = Benchmark.realtime do
    block.call
  end.round(2)

  puts "- Total: #{time}s"
  puts
end

log "truncate database" do
  ActiveRecord::Base.connection.tables.each do |table|
    next if table == "schema_migrations"
    ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
    ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='#{table}'")
  end
end

log 'create users' do
  user = User.new(
    name: 'John',
    email: 'user1@example.com',
    password: '12345678'
  )
  user.save!
  puts 'user1@example.com - 12345678'
  user = User.new(
    name: 'John',
    email: 'user2@example.com',
    password: '12345678'
  )
  user.save!
  puts 'user2@example.com - 12345678'
end


log 'create products' do
  User.first.products.create!(vendor: 'Apple', model:'MacBook Pro', price_in_cents: 129900)
  User.first.products.create!(vendor: 'Apple', model:'MacBook Air', price_in_cents: 99900)
  User.first.products.create!(vendor: 'Apple', model:'iPad 4', price_in_cents: 69900)
  User.first.products.create!(vendor: 'Apple', model:'iPad 3', price_in_cents: 49900)
  User.first.products.create!(vendor: 'Apple', model:'iPad 2', price_in_cents: 29900)
  User.first.products.create!(vendor: 'Apple', model:'iPhone 5', price_in_cents: 79900)
  User.first.products.create!(vendor: 'Apple', model:'iPhone 4', price_in_cents: 59900)
  User.first.products.create!(vendor: 'Apple', model:'iPhone 3', price_in_cents: 39900)
  User.first.products.create!(vendor: 'Apple', model:'Mac Mini', price_in_cents: 39900)
  User.last.products.create!(vendor: 'Google', model:'Nexus 10', price_in_cents: 60000)
  User.last.products.create!(vendor: 'Google', model:'Nexus 7', price_in_cents: 40000)
  User.last.products.create!(vendor: 'Google', model:'Nexus 4', price_in_cents: 20000)
end
