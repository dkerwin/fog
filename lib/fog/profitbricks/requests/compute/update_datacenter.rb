module Fog
  module Compute
    class ProfitBricks
      class Real

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
        def update_datacenter(options)
          request(
            :expects => 200,
            :method  => 'POST',
            :path    => '/1.2',
            :parser  => Fog::ToHashDocument.new,
            :body    => %Q{<ws:updateDataCenter><arg0>#{options.map {|k,v| "<#{k}>#{v}</#{k}>" }.join}</arg0></ws:updateDataCenter>}
          )
        end

      end
    end
  end
end
