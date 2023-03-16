require 'csv'
require 'git'

# Load the sequence CSV file into memory
sequence = CSV.read('sequence.csv', headers: true)

# Create an empty hash to store the temperature data for each city and timestamp
temperature_data = {}

# Iterate over each row in the sequence
sequence.each do |row|
  city = row['city']
  temperature = row['temperature']
  timestamp = row['timestamp']

  # If we haven't seen this city before, create a new hash for it
  if !temperature_data[city]
    temperature_data[city] = {}
  end

  # Add the temperature for this city and timestamp
  temperature_data[city][timestamp] = temperature
end

# Create an empty array to store the timestamps
timestamps = []

# Use Git to get the list of commit timestamps
g = Git.open('.')
g.log.each do |commit|
  timestamps << commit.date
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
