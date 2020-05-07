require_relative "../../../run_data"

module Inspec::Plugin::V2::PluginType
  class Reporter < Inspec::Plugin::V2::PluginBase
    register_plugin_type(:reporter)

    attr_reader :run_data

    def initialize(config)
      @config = config
      unless Inspec::RunData.compatible_schema?(self.class.run_data_schema_constraints)
        # Best we can do is warn here, the InSpec run has finished
        # TODO: one day, perhaps switch RunData implementations to try to satisfy constraints?
        Inspec::Log.warn "Reporter does not support RunData API (#{Inspec::RunData::SCHEMA_VERSION}), Reporter constraints: '#{self.class.run_data_schema_constraints}'"
      end
      @run_data = Inspec::RunData.new(config[:run_data])
      @output = ""
    end

    def output(str, newline = true)
      @output << str
      @output << "\n" if newline
    end

    def rendered_output
      @output
    end

    # each reporter must implement #render
    def render
      raise NotImplementedError, "#{self.class} must implement a `#render` method to format its output."
    end

    def self.run_data_schema_constraints
      raise NotImplementedError, "#{self.class} must implement a `run_data_schema_constraints` class method to declare its compatibiltity with the RunData API."
    end
  end
end
