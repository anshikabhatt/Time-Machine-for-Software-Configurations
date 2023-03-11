require 'csv'

sequence = CSV.read('sequence.csv', headers: true)

sequence.sort_by! { |row| row['timestamp'] }.reverse!

# Create an empty hash to store the most recent temperature for each city
latest_temperatures = {}

# Iterate over each row in the sequence
sequence.each do |row|
  city = row['city']
  temperature = row['temperature']

  if !latest_temperatures[city]
    latest_temperatures[city] = temperature

  elsif row['timestamp'] > latest_temperatures[city + '_timestamp']
    latest_temperatures[city] = temperature
  end

  latest_temperatures[city + '_timestamp'] = row['timestamp']
end

# Output the latest temperature data for each city
puts "city,temperature"
latest_temperatures.each do |city, temperature|
  if !city.include?('_timestamp')
    puts "#{city},#{temperature}"
  end
end
