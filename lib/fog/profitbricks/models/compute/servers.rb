require 'fog/core/collection'
require 'fog/profitbricks/models/compute/server'

module Fog
  module Compute
    class ProfitBricks

      class Servers < Fog::Collection

        model Fog::Compute::ProfitBricks::Server

        def all()
          raise ArgumentError.new("Please use datacenters.get(DATACENTER_ID).servers instead")
        end

        def get(id)
          return nil if id.nil? || id == ""
          data = service.get_server(id).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
