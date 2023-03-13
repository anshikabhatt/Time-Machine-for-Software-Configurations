class TimeMachine
  attr_reader :configurations

  def initialize(directory)
    @configurations = parse_directory(directory)
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
