require 'json'

class Configurations
  attr_reader :configurations

  def initialize(directory)
    @configurations = parse_directory(directory)
  end

  def get_configuration(name)
    @configurations[name]
  end

  private

  def parse_directory(directory)
    configurations = {}

    Dir.glob(File.join(directory, '*.json')).sort.each do |file|
      configuration = parse_file(file)
      configurations[configuration['name']] = configuration
    end

    configurations
  end

  def parse_file(file)
    JSON.parse(File.read(file))
  end
end

class TimeMachine
  attr_reader :configurations

  def initialize(directory)
    @configurations = Configurations.new(directory)
  end

  def snapshots
    snapshot_files.map do |file|
      timestamp = parse_timestamp(file)
      data = parse_data(file)
      Snapshot.new(timestamp, data)
    end
  end

  private

  def snapshot_files
    Dir.glob(File.join(configurations.configurations['snapshots_directory'], '*.json')).sort
  end

  def parse_timestamp(file)
    File.basename(file, '.json').to_i
  end

  def parse_data(file)
    JSON.parse(File.read(file))
  end
end

class Snapshot
  attr_reader :timestamp, :data

  def initialize(timestamp, data)
    @timestamp = timestamp
    @data = data
  end
end
