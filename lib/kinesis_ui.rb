require "kinesis_ui/version"
require "kinesis_ui/engine"
require "kinesis_ui/configuration"

module KinesisUi
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
