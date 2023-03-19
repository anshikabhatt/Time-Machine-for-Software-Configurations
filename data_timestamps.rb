require 'csv'
require 'git'
require 'time'

# Load the sequence CSV file into memory
sequence = CSV.read('sequence.csv', headers: true)

# Create an empty hash to store the temperature data for each city and timestamp
temperature_data = {}

# Iterate over each row in the sequence
sequence.each do |row|
  city = row['city']
  temperature = row['temperature']

  # Convert temperature to a float if it is not nil
  temperature = temperature.to_f if temperature

  # If we haven't seen this city before, create a new hash for it
  temperature_data[city] ||= {}

  # Add the temperature for this city and current timestamp
  temperature_data[city][Time.now.iso8601] = temperature
end

# Create an empty array to store the timestamps
timestamps = []

# Use Git to get the list of commit timestamps
g = Git.open('.')
g.log.each do |commit|
  timestamps << commit.date.iso8601
end

# Add the temperature data for each timestamp to a CSV file
CSV.open('temperature_data.csv', 'w') do |csv|
  csv << ['timestamp', 'city', 'temperature']
  timestamps.each do |timestamp|
    temperature_data.each do |city, data|
      temperature = data[timestamp]

      # If there is no temperature data for this city and timestamp, write a row indicating no data is available
      if !temperature
        csv << [timestamp, city, 'No data available']
      else
        csv << [timestamp, city, temperature]
      end
    end
  end
end

