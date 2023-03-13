require_relative 'my_parser'
require_relative 'time_machine'

tm = TimeMachine.new('C:/Users/Az/evolutionOverTime')
snapshots = tm.snapshots

snapshots.each do |snapshot|
  puts "Timestamp: #{snapshot.timestamp}"
  puts "Data:"
  snapshot.data.each do |row|
    puts "#{row['city']}: #{row['temperature']} degrees Celsius"
  end
end


