require_relative File.expand_path('my_parser', __dir__)

tm = TimeMachine.new('C:/Users/Az/evolutionOverTime')
snapshots = tm.snapshots

snapshots.each do |snapshot|
  puts "Timestamp: #{snapshot.timestamp}"
  puts "Data:"
  snapshot.data.each do |row|
    puts "#{row['city']}: #{row['temperature']} degrees Celsius"
  end
end
