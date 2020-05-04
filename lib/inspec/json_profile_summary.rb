# frozen_string_literal: true

module Inspec
    #
    # Inspec::InspecCLI::JsonProfileSummary takes in certain information to identify a
    # profile and then produces a JSON-formatted summary of that profile. It can
    # return the results to STDOUT or a file. It is currently used in several
    # places in the CLI such as `json`, `archive` and `artifact`.
    #
    #
    module JsonProfileSummary
      def self.produce_json(info:, dst: [], suppress_output: false)
        # add in inspec version
        info[:generator] = {
          name: "inspec",
          version: Inspec::VERSION,
        }
        if dst.empty?
          puts JSON.dump(info)
        else
          unless suppress_output
            if File.exist? dst
              puts "----> updating #{dst}"
            else
              puts "----> creating #{dst}"
            end
          end
          fdst = File.expand_path(dst)
          File.write(fdst, JSON.dump(info))
        end
      end
  end
end
