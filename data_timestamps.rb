require 'csv'

# Load the sequence CSV file into memory
sequence = CSV.read('sequence.csv', headers: true)

# Sort the sequence by timestamp in descending order
sequence.sort_by! { |row| row['timestamp'] }.reverse!

# Create an empty hash to store the most recent temperature for each city
latest_temperatures = {}

# Iterate over each row in the sequence
sequence.each do |row|
  city = row['city']
  temperature = row['temperature']

  # If we haven't seen this city before, add it to the hash with the current temperature
  if !latest_temperatures[city]
    latest_temperatures[city] = temperature

  # If we have seen this city before, update the temperature if the current timestamp is more recent
  elsif row['timestamp'] > latest_temperatures[city + '_timestamp']
    latest_temperatures[city] = temperature
  end

  # Store the timestamp for this city
  latest_temperatures[city + '_timestamp'] = row['timestamp']
end

# Add the latest temperature data for each city to a CSV file with a timestamp
CSV.open('latest_temperatures.csv', 'a') do |csv|
  csv << ['timestamp', 'city', 'temperature']
  latest_temperatures.each do |city, temperature|
    if !city.include?('_timestamp')
      csv << [Time.now, city, temperature]
    end
  end
end
