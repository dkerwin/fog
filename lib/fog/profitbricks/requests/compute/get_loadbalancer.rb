module Fog
  module Compute
    class ProfitBricks
      class Real

        require 'fog/profitbricks/parsers/compute/get_loadbalancer'

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
        def get_loadbalancer(id)
          request(
            :expects => 200,
            :method  => 'POST',
            :parser  => Fog::Parsers::Compute::ProfitBricks::GetLoadbalancer.new,
            :path    => '/1.2',
            :body    => %Q{<ws:getLoadBalancer><loadBalancerId>#{id}</loadBalancerId></ws:getLoadBalancer>}
          )
        end

      end
    end
  end
end
