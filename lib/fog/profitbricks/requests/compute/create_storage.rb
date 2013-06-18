module Fog
  module Compute
    class ProfitBricks
      class Real

        require 'fog/profitbricks/parsers/compute/create_storage'

        # Boot a new server
        #
        # ==== Parameters
        # * planId<~String> - The id of the plan to boot the server with
        # * options<~Hash>: optional extra arguments
        #   * imageId<~String>  - Optional image to boot server from
        #   * name<~String>     - Name to boot new server with
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'server'<~Hash>:
        #       * 'id'<~String> - Id of the image
        #
        def create_storage(options)
          request(
            :expects => 200,
            :method  => 'POST',
            :parser  => Fog::Parsers::Compute::ProfitBricks::CreateStorage.new,
            :path    => '/1.2',
            :body    => %Q{<ws:createStorage><arg0>#{options.map {|k,v| "<#{k}>#{v}</#{k}>" }.join}</arg0></ws:createStorage>}
          )
        end

      end
    end
  end
end
